(* ::Package:: *)

(* ::Section:: *)
(*Setting*)


SetDirectory@NotebookDirectory[];


(* ::Section:: *)
(*Data*)


data1 := data1 = GeneralUtilities`Scope[
	Print@Hyperlink["https://github.com/by-syk/chinese-idiom-db"];
	r := URLDownload[
		"https://github.com/by-syk/chinese-idiom-db/raw/master/chinese-idioms-12976.txt",
		"Source_1.mx"
	];
	If[!FileExistsQ@"Source_1.mx", r];
	tmp = Import["Source_1.mx", "CSV"];
	Echo[Length@tmp, "Records:"];
	tmp[[All, {2, 3, 4}]]
];


data2 := data2 = GeneralUtilities`Scope[
	Print@Hyperlink["https://github.com/pwxcoo/chinese-xinhua"];
	r := URLDownload[
		"https://github.com/pwxcoo/chinese-xinhua/raw/master/data/idiom.json",
		"Source_2.mx"
	];
	If[!FileExistsQ@"Source_2.mx", r];
	tmp = Import["Source_2.mx", "RawJSON"];
	Echo[Length@tmp, "Records:"];
	Values /@ tmp[[All, {"word", "pinyin", "explanation"}]]
];


data3 := data3 = GeneralUtilities`Scope[
	Print@Hyperlink["https://github.com/pwxcoo/chinese-xinhua"];
	r := URLDownload[
		"https://raw.githubusercontent.com/pwxcoo/chinese-xinhua/master/data/ci.json",
		"Source_3.mx"
	];
	If[!FileExistsQ@"Source_3.mx", r];
	tmp = Import["Source_3.mx", "RawJSON"];
	Echo[Length@tmp, "Records:"];
	GroupBy[tmp, StringLength@#ci&][4]
(*Values /@ tmp[[All, {"word", "pinyin", "explanation"}]]*)
];


data = MapAt[StringRiffle@*StringSplit, Join[data1, data2], {All, 2}];
data = SortBy[Append[#, ""]& /@ DeleteDuplicatesBy[data, First], Rest];


(* ::Section:: *)
(*Export Base*)


(* ::Subsection:: *)
(*Export*)


Export[
	"database-base.csv",
	Select[data, StringLength@First[#] > 3&],
	"TableHeadings" -> {"Idiom", "Pinyin", "Explanation", "Synonym"},
	CharacterEncoding -> "UTF8"
];


(* ::Subsection:: *)
(*Export Accelerate*)


(* ::Input:: *)
(*string = ExportString[*)
(*	SortBy[data, Rest], "CSV",*)
(*	"TableHeadings" -> {"Idiom", "Pinyin", "Explanation"},*)
(*	CharacterEncoding -> "UTF8"*)
(*];*)
(*Export["database.csv", string, "Table", CharacterEncoding -> "UTF8"]*)


(* ::Section:: *)
(*Export Other*)


Export[
	"database-3char.csv",
	GroupBy[data[[All, ;; 3]], StringLength@*First][3],
	"TableHeadings" -> {"Idiom", "Pinyin", "Explanation"},
	CharacterEncoding -> "UTF8"
];


(* ::Input:: *)
(*formatter=<|"Word"->#ci,"Explanation"->#explanation|>&*)
(*Query[All,formatter][Dataset@data3]*)
