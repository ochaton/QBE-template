my $block_match = qr/(?<label>@\S+)\n(?<block>[^@]+)/;
my $rd_in_match = qr/rd_in\s*=(?<vars>\s*(?:\s+(%\S+))+)?/;

use Exporter;
our @EXPORT_OK = our @EXPORT = qw(canonicalize);

sub canonicalize {
	my $text = shift;

	my @ret;
	while ($text =~ m/\G$block_match/g) {
		my %r = (label => $+{label});
		my $block = $+{block};
		my ($rd_in) = $block =~ m/$rd_in_match/g; $rd_in=~s/^\s+//g; @{$r{rd_in}} = sort split /\s+/, $rd_in;

		push @ret, \%r;
	}
	return \@ret;
}

return \&canonicalize;
