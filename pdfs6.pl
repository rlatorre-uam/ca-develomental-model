#!/usr/bin/perl

	my $gnuplot="output.par.gnuplot";
	open fo,"> $gnuplot" or die "no sobre";

    print fo "set term wxt size 1000,1000 ; \n";
    print fo "set term wxt title 'GNUWindow7' ; \n";
	print fo "set terminal push ;\n";
           
       print fo "set autoscale; \n";       
       print fo "unset key ; \n";
       print fo "set pm3d map; \n";
       print fo "set size square; \n";

	$ei="splot \\";
	chomp;
	print fo "$ei\n";
	$ei="'autom.dat' matrix with image;";

	chomp;
	print fo "$ei\n";

	my $crida= "gnuplot -persist $gnuplot";
	system($crida);


