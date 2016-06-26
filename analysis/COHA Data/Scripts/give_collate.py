import os
from os import path
import zipfile

files = [x for x in os.listdir('.') if path.isfile('.'+os.sep+x)]

infile = open('sources_coha.txt')
names = infile.readline().rstrip().split('\t')

texts = {}

for line in infile:
	s = line.rstrip().split('\t')
	texts[s[0]] = {}
	for n in range(1,len(s)-1,1):
		texts[s[0]][names[n]] = s[n]

outfile = open('coha_gives.txt','w')

outfile.write('id\tstartnum\tendnum\ttextname\tauthor\tgenre\tyear\ttoken')

for f in files:
	if zipfile.is_zipfile(f):
		zf = zipfile.ZipFile(f)
		zf_names = zf.namelist()
		for name in zf_names:
			print name
			idt = name.split('.')[0].split('_')[2]
			if idt not in texts.keys():
				continue
			cur_text = texts[idt]
			cur_file = zf.open(name)
			try:
				cur_title = cur_text['title']
			except:
				cur_title = ''
			try:
				cur_author = cur_text['author']
			except:
				cur_author = ''
			startword = 0
			curword = 0
			cur_token = ''
			has_give = 0
			for line in cur_file:
				s = line.rstrip().split('\t')
				try:
					cur_token += ' '+s[0]+'-~'+s[1]+'::'+s[2]
					if (s[1] in ['.','!','?']) or (s[0] == '@' and s[2] == 'ii'):
						if has_give:
							outfile.write(str(idt)+'\t'+str(startword)+'\t'+str(curword)+'\t'+cur_title+'\t'+cur_author+'\t'+cur_text['genre']+'\t'+cur_text['year']+'\t'+cur_token+'\n')
						cur_token = ''
						startword = curword + 1
						has_give = 0
					elif s[1] == 'give':
						has_give = 1
				except:
					continue
				curword += 1
