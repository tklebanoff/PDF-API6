use v6;
use PDF::API6;
use PDF::Page;

my PDF::API6 $pdf .= new;
use PDF::Destination :Fit;

for 1..4 -> $page-no {
    my PDF::Page $page = $pdf.add-page;
    $page.media-box = [0, 0, 450, 400];
    $page.text: {
        .font = .core-font( :family<Courier>, :weight<bold> );
        .text-position = [10, 350];

        .say: "Page $page-no/3";
        .say;
        .say: "This PDF have preferences:";
        .say: " :hide-toolbar    (toolbar should not appear in reader)";
        .say: " :page(2)         (document should open on page 2)";
        .say: " :fit(FitWindow)  (contents should scale to fit window)";
    }
}

sub dest(|c) { :Dest($pdf.destination(|c)) }

my @outlines = [
          %( :Title('1. Sample Heading-1'), dest(:page(1))),
          %( :Title('2. Sample Heading-2'), dest(:page(2))),
          %( :Title('3. Sample Heading-3'), dest(:page(3),
                %( :Title('3.1. Sub Heading'),   dest(:page(3)) ),
                %( :Title('3.1. Sub Heading'),   dest(:page(3)) ),
             ],
           ),
          %( :Title('Appendix'), dest(:page(4))),
         ]

my @page-labels = 0 => 'i',    # roman page numbering: i, ii
                  1 => 1,      # regular page numbering: 1, 2
                  3 =>  'A-1'; # Appendix A-1, S2...

$pdf.preferences: :hide-toolbar, :start{ :page(2), :fit(FitWindow), :@outlines, :@page-labels };
$pdf.save-as: "preferences.pdf";


