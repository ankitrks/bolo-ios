from bs4 import BeautifulSoup
import requests, xlsxwriter
import csv 

## Opening a excel file and adding column names
# wb = xlsxwriter.Workbook("PharmacyData.xlsx")
# sheet = wb.add_worksheet("Dataset")
url = requests.get("https://www.apollodiagnostics.in/for-patients/test-booking/Pune/")
soup = BeautifulSoup(url.content)
container = soup.findAll('li')
print(container)
