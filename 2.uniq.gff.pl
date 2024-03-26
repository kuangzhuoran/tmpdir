#!/usr/bin/perl
use strict;
use warnings;

# 检查命令行参数
my $usage = "Usage: $0 <input.gff>\n";
my $infile = shift or die $usage;

# 打开GFF文件进行读取
open(my $fh, '<', $infile) or die "Cannot open file $infile: $!";

# 使用哈希表来跟踪前八列的唯一组合
my %seen;

while (my $line = <$fh>) {
    chomp $line;
    # 跳过注释行
    next if $line =~ /^\s*#/;

    # 分割行以获取各列
    my @cols = split(/\t/, $line);

    # 检查是否至少有八列
    if (@cols < 8) {
        warn "Ignoring line with less than 8 columns: $line\n";
        next;
    }

    # 构造一个键，由前八列通过特定分隔符连接而成，用于判断是否已经见过这个组合
    my $key = join("::", @cols[0..7]);

    # 如果这个键还没有见过，就打印这一行，并标记为已见
    unless ($seen{$key}++) {
        print "$line\n";
    }
}

close($fh);
