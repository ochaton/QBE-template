my $block_match = qr/(?<label>@\S+)\n(?<block>[^@]+)/;
my $kill_match = qr/kill\s*=(?<vars>\s*(?:\s+(%\S+))+)?/;
my $gen_match = qr/gen\s*=(?<vars>\s*(?:\s+(%\S+))+)?/;

use Exporter;
our @EXPORT_OK = our @EXPORT = qw(canonicalize);

sub canonicalize {
	my $text = shift;

	my @ret;
	while ($text =~ m/\G$block_match/g) {
		my %r = (label => $+{label});
		my $block = $+{block};
		my ($gen) = $block =~ m/$gen_match/g; $gen=~s/^\s+//g; @{$r{gen}} = sort split /\s+/, $gen;
		my ($kill) = $block =~ m/$kill_match/g; $kill=~s/^\s+//g; @{$r{kill}} = sort split /\s+/, $kill;

		push @ret, \%r;
	}
	return \@ret;
}

return \&canonicalize;
