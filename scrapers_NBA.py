from bs4 import BeautifulSoup
import requests
import time
import re
import csv
import sys
import unidecode
"""
scraping methods
"""
urlbase = 'http://www.espn.com/nba/salaries/_/year/'
urlbase2 = 'http://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&type=totals&per_minute_base=36&per_poss_base=100&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=2000&year_max=2017&birth_country_is=Y&as_comp=gt&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&force%3Apos_is=1&c6mult=1.0&order_by=ws&offset='
urlbase3 = 'http://insider.espn.com/nba/hollinger/statistics/_/page/'
urlbase4 = 'https://en.wikipedia.org/wiki/List_of_foreign_NBA_players'
offsets = ['0','1400']
years = ['2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015',
		 '2016']
years_PER = ['2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015',
		 '2016']

def get_salary():

	with open('player_salary.csv', 'wt') as output_file:
		writer = csv.writer(output_file,delimiter=',')
		writer.writerow(('YEAR','PLAYER', 'SALARY'))
		dic = dict();
		regex_name = r'[^,]*'
		for year in years:
			for i in range(10):
				print urlbase+str(year)+'/page/'+str(i+1)
				html = requests.get(urlbase+str(year)+'/page/'+str(i+1)).text
				soup = BeautifulSoup(html,'html5lib')
				important = [player for table in soup('table')
							 for player in table('tr')]
				if len(important) <= 1:
					continue
				for i in important:
					alltds = i.findAll('td')
					if (alltds):
						if (alltds[1].text == 'NAME'):
							continue
						writer.writerow((year,re.findall(regex_name,alltds[1].text)[0],alltds[3].text))

def get_player_stats():

	dic = dict();
	with open('result.csv', 'wt') as output_file:
		writer = csv.writer(output_file,delimiter=',')
		writer.writerow(('YEAR','PLAYER', 'GP', 'MPG', 'TS','AST', 'TO', 'USG', 'ORR','DRR','REBR','PER','VA','EWA'))
		regex_name = r'[^,]*'
		for year in years_PER:
			for i in range(15):
				print urlbase3+str(i+1)+'/year/'+str(year)+'/qualified/false'
				html = requests.get(urlbase3+str(i+1)+'/year/'+years_PER[0]+'/qualified/false').text
				soup = BeautifulSoup(html,'html5lib')
				important = [row for row in soup('tr')]
				print len(important)
				for i in important:
					alltds = i.findAll('td')
					if len(alltds) >= 10 and alltds[0].text != 'RK':
						writer.writerow((year,(re.findall(regex_name,alltds[1].text)[0]),alltds[2].text,alltds[3].text,alltds[4].text,alltds[5].text,
										 alltds[6].text,alltds[7].text,
										alltds[8].text,alltds[9].text,alltds[10].text,alltds[11].text,
										alltds[12].text,alltds[13].text))



def get_player_stats_PER():
	idx = 0
	while (idx <= 8200):
		html = requests.get(urlbase2+str(idx)).text
		soup = BeautifulSoup(html,'html5lib')
		important = [tr for tr in soup('tr')]
		for i in important:
			if i.find('td',{'data-stat':'player'}):
				print i.find('td',{'data-stat':'player'}).text
				print i.find('td',{'data-stat':'season'}).text
				print i.find('td',{'data-stat':'age'}).text
				print i.find('td', {'data-stat': 'team_id'}).text
				print i.find('td', {'data-stat': 'lg_id'}).text
				print i.find('td', {'data-stat': 'ws'}).text
				print i.find('td', {'data-stat': 'g'}).text
				print i.find('td', {'data-stat': 'gs'}).text
				print i.find('td', {'data-stat': 'mp'}).text
				print i.find('td', {'data-stat': 'fg'}).text
				print i.find('td', {'data-stat': 'fga'}).text
				print i.find('td', {'data-stat': 'fg2'}).text
				print i.find('td', {'data-stat': 'fg2a'}).text
				print i.find('td', {'data-stat': 'fg3'}).text
				print i.find('td', {'data-stat': 'fg3a'}).text
				print i.find('td', {'data-stat': 'ft'}).text
				print i.find('td', {'data-stat': 'fta'}).text
				print i.find('td', {'data-stat': 'ast'}).text
				print i.find('td', {'data-stat': 'stl'}).text
				print i.find('td', {'data-stat': 'blk'}).text
				print i.find('td', {'data-stat': 'tov'}).text
				print i.find('td', {'data-stat': 'pf'}).text
				print i.find('td', {'data-stat': 'pts'}).text
				print i.find('td', {'data-stat': 'fg_pct'}).text
				print i.find('td', {'data-stat': 'fg2_pct'}).text
				print i.find('td', {'data-stat': 'fg3_pct'}).text
				print i.find('td', {'data-stat': 'efg_pct'}).text
				print i.find('td', {'data-stat': 'ft_pct'}).text
				print i.find('td', {'data-stat': 'ts_pct'}).text
				time.sleep(5)
		idx = idx + 100
	print len(important)

def get_international_players():
	with open('international_players.csv', 'wt') as output_file:
		regex_name = r'([^-]*)'
		writer = csv.writer(output_file,delimiter=',')
		writer.writerow(('YEAR','PLAYER', 'POS','COUNTRY'))
		html = requests.get(urlbase4).text
		soup = BeautifulSoup(html, 'html5lib')
		tables = [table for table in soup('table',{'class':'wikitable sortable','style':'font-size:95%'})]
		table = tables[0]
		important = [tr for tr in table.findAll('tr')]
		for i in important:
			alltds = i.findAll('td')
			if (len(alltds) >= 4):
				# print rregex_name,alltds[4].text)[0].strip()
				# print re.findall(regex_name,alltds[2].text)[1].strip()
				# print re.findall(regex_name,alltds[3].text)[0].strip()
				# print re.findall(regex_name,alltds[0].text)[0].strip()
				played_years = (unidecode.unidecode(alltds[4].findAll('a')[0].text.strip())).split('-')
				played_year = 0;
				if len(played_years) > 1:
					played_year = played_years[1]
				else:
					played_year = played_years[0]
				writer.writerow((played_year,
								 unidecode.unidecode(alltds[2].a.text.strip()),
								 unidecode.unidecode(alltds[3].text.strip()),
								 unidecode.unidecode(alltds[0].text.strip())))


if __name__ == "__main__":
	# get_international_players()
	# get_player_stats_PER()
	# get_salary()

		
