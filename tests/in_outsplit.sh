for f in *.test; do
	cat $f | perl -lnaE 'BEGIN{ $p = shift}; $s=3 if /--- Correct/; push @input, $_ if $s==1; $s=1 if /--- Input/; push @output, $_ if $s==2; $s=2 if /--- Output/;}{ $,="\n"; delete $input[$#input]; open $in,">","$p.input";open$out,">","$p.output"; print $in join"\n", @input; print $out join"\n",@output' $f;
done;
