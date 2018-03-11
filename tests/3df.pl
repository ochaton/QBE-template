my $block_match = qr/(?<label>@[^:]+):[ \t]*(?<blocks>[^\n]*)\n/;

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

# use DDP; p canonicalize do { local $/; <DATA> };

return \&canonicalize;
__DATA__
@start:
@loop:	@loop
@end:
