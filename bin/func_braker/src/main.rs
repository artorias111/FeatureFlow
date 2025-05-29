use bio::io::gff;

fn main() {
    let _output_path = "annotated_braker.gff3";
    let gff_path = "/data2/work/Notothenioids/Dmaw12/Dmaw12_Hifiasm+purgeHap+arks_Bionano_Scaffolds/FeatureFlow/results/Braker3/braker/braker.gff3";

    let _interpro_path = "/test/path";

    let mut gff_reader = gff::Reader::from_file(gff_path, gff::GffType::GFF3)
        .expect("Failed to open the gff3 file");

    for record in gff_reader.records() { 
        let mut rec = record.expect("Erorr reading gff record");
        if rec.feature_type() == "mRNA" {
            let attributes = rec.attributes_mut();

            attributes.insert("GO".to_string(), "56565".to_string());

            println!("Modified attributes: {:?}", attributes);

                
        }
    }
}
