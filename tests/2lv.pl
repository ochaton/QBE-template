my $block_match = qr/(?<label>@\S+)\n(?<block>[^@]+)/;
my $lv_out_match = qr/lv_out\s*=(?<vars>\s*(?:\s+(%\S+))+)?/;

use Exporter;
our @EXPORT_OK = our @EXPORT = qw(canonicalize);

sub canonicalize {
	my $text = shift;

	my @ret;
	while ($text =~ m/\G$block_match/g) {
		my %r = (label => $+{label});
		my $block = $+{block};
		my ($lv_out) = $block =~ m/$lv_out_match/g; $lv_out=~s/^\s+//g; @{$r{lv_out}} = sort split /\s+/, $lv_out;

		push @ret, \%r;
	}
	return \@ret;
}

return \&canonicalize;
