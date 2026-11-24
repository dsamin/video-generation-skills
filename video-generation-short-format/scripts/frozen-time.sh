#!/bin/sh
# Near-frozen time in a render: frame-to-frame luma difference below a threshold, sampled at 10 fps.
# Idea and thresholds from the motion-video-kit "quality bar" (github.com/echris6/motion-video-kit, MIT); this is our own awk.
# Usage: sh frozen-time.sh out/NN-slug.mp4 [threshold=0.35]
# Prints the total near-frozen seconds, the longest hold, and every hold of 0.6 s or more (start time, length).
f="$1"; th="${2:-0.35}"
ffmpeg -hide_banner -i "$f" -vf "fps=10,scale=320:-1,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG" -an -f null - 2>&1 \
 | grep -o "YAVG=[0-9.]*" | awk -F= -v th="$th" '
   { v=$2; t=NR/10;
     if (v<th) { if (!run) start=t; run++; n++ }
     else if (run) { if (run>=6) { holds[++h]=sprintf("%.1fs (%.1fs)", start, run/10) } if (run>mx) mx=run; run=0 } }
   END { if (run) { if (run>=6) holds[++h]=sprintf("%.1fs (%.1fs)", start, run/10); if (run>mx) mx=run }
         printf "near-frozen: %.1fs of %.1fs (%.0f%%), longest hold %.1fs\n", n/10, NR/10, 100*n/NR, mx/10;
         printf "holds >= 0.6s:"; for (i=1;i<=h;i++) printf " %s", holds[i]; printf "\n" }'
