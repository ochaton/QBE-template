my $block_match = qr/(?<label>@\S+)\s*(?<blocks>[^\n]+)\s*\n/;

use Exporter;
our @EXPORT_OK = our @EXPORT = qw(canonicalize);

sub canonicalize {
	my $text = shift;

	my @ret;
	while ($text =~ m/\G$block_match/g) {
		my %r = (label => $+{label});
		$r{blocks} = [ grep { length } sort split /\s+/, $+{blocks} ];
		push @ret, \%r;
	}
	@ret = sort { $a->{label} cmp $b->{label} } @ret;
	return \@ret;
}

return \&canonicalize;
__DATA__
@start	@start @loop @end 
@loop	@loop @end 
@end	@end 

