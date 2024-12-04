medicines = [
    ("Paracetamol", "Calpol", 20.50, "fever", True),
    ("Ibuprofen", "Brufen", 50.00, "pain", True),
    ("Cetirizine", "Cetzine", 15.75, "allergy", True),
    ("Amoxicillin", "Amoxil", 120.00, "antibiotic", True),
    ("Omeprazole", "Omez", 80.00, "acidity", True),
    ("Metformin", "Glyciphage", 90.00, "diabetes", True),
    ("Losartan", "Losar", 70.00, "hypertension", True),
    ("Salbutamol", "Asthalin", 30.00, "asthma", True),
    ("Ranitidine", "Zinetac", 25.00, "ulcers", False),
    ("Hydroxychloroquine", "HCQ", 150.00, "malaria", True),
    ("Aspirin", "Ecosprin", 40.00, "pain", True),
    ("Clopidogrel", "Plavix", 120.00, "heart", True),
    ("Atorvastatin", "Lipitor", 110.00, "cholesterol", True),
    ("Montelukast", "Montair", 95.00, "allergy", True),
    ("Levothyroxine", "Thyronorm", 75.00, "thyroid", True),
    ("Gliclazide", "Diamicron", 100.00, "diabetes", True),
    ("Azithromycin", "Zithromax", 150.00, "antibiotic", True),
    ("Doxycycline", "Doxinate", 130.00, "antibiotic", False),
    ("Furosemide", "Lasix", 65.00, "diuretic", True),
    ("Prednisolone", "Omnacortil", 85.00, "steroid", True),
    ("Pantoprazole", "Pantocid", 90.00, "acidity", True),
    ("Diclofenac", "Voveran", 50.00, "pain", True),
    ("Ciprofloxacin", "Ciplox", 110.00, "antibiotic", True),
    ("Insulin Glargine", "Lantus", 300.00, "diabetes", True),
]

from random import randrange
from datetime import timedelta
from datetime import datetime

def random_date(start, end):
    """
    This function will return a random datetime between two datetime
    objects.
    """
    delta = end - start
    int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
    random_second = randrange(int_delta)
    return start + timedelta(seconds=random_second)

for m in medicines:
    a, b, c, d, e = m
    d1 =  random_date(datetime.now(), datetime(2040, 1, 1)).date()
    print(f"INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='{b}'),'{b}', 1000, '{d1}') ON CONFLICT DO NOTHING;")
    print(
        f"INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='{b}'),'{b}', 1000, '{d1}') ON CONFLICT DO NOTHING;")