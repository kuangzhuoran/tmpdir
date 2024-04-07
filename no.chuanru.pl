#!/usr/bin/perl

use strict;
use warnings;

# 读取文件A
open(my $fileA, '<', '文件A') or die "无法打开文件A: $!";

# 遍历文件A的每一行
while (my $line = <$fileA>) {
    chomp $line;
    my ($编号, $物种名, $accession) = split(/\t/, $line);

    # 构建新的文件名
    my $new_filename = "$accession\_$物种名.fa";

    # 查找对应的文件夹
    my $folder_path = "/path/to/NCBI文件夹/$accession";

    # 检查文件夹是否存在
    unless (-d $folder_path) {
        warn "文件夹 $folder_path 不存在，跳过该行数据\n";
        next;
    }

    # 查找基因组文件
    my @files = glob("$folder_path/*_genomic.fna");

    # 检查是否找到基因组文件
    unless (@files) {
        warn "文件夹 $folder_path 中没有找到基因组文件，跳过该行数据\n";
        next;
    }

    # 假设只有一个基因组文件，如果有多个文件可以根据需求进行处理
    my $old_filename = $files[0];

    # 构建新的文件路径
    my $new_filepath = $folder_path . "/" . $new_filename;

    # 重命名文件
    rename $old_filename, $new_filepath or warn "无法重命名文件: $!";
}

# 关闭文件A
close($fileA);
