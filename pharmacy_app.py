drugs = "Lyrica Melatonin Meloxicam Metformin Methadone Methotrexate Metoprolol Mounjaro Naltrexone Naproxen Narcan Nurtec Omeprazole Opdivo Otezla Ozempic Pantoprazole Plan B Prednisone".split(" ")
for i in range(len(drugs)):
    print("insert into stock(branch_id,drug_id, drug_name, amount) values (1, {0}, '{1}', 1000) ON CONFLICT DO NOTHING;".format(i+11, drugs[i]))
    print(
        "insert into stock(branch_id,drug_id, drug_name, amount) values (2, {0}, '{1}', 1000) ON CONFLICT DO NOTHING;".format(
            i + 11, drugs[i]))
