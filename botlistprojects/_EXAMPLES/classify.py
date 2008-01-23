"""
"""

import re

def getwords(doc):
	print "***** getwords ****************"
	splitter = re.compile('\\W*')
	print doc
	words = [s.lower() for s in splitter.split(doc) 
			 if len(s) > 2 and len(s) < 20]
	# Return the unique set of words only
	return dict([(w,1) for w in words])
  
class classify:
	def __init__(self, gf, filename = None):
		self.fc = {}
		self.cc = {}
		print gf
		self.getdata = gf

		
	def inc_f(self, f, cat):
		self.fc.setdefault(f, {})
		self.fc[f].setdefault(cat, 0)
		self.fc[f][cat] += 1
		print self.fc
		print self.fc[f]
		print "***************"

	def inc_c(self, cat):
		self.cc.setdefault(cat, 0)
		self.cc[cat] += 1

	def fcount(self, f, cat):
		if f in self.fc and cat in self.fc[f]:
			return float(self.fc[f][cat])
		return 0.0

	def catcount(self, cat):
		if cat in self.cc:
			return float(self.cc[cat])
		return 0

	def totalcount(self):
		return sum(self.cc.values())

	def categories(self):
		return self.cc.keys()

	def train(self, item, cat):
		self.getdata(item)
		features = self.getdata(item)
		if features is None:
			return
		
		print len(features)
		print "------------------------"
		for f in features:
			self.inc_f(f, cat)
		self.inc_c(cat)

###
###
class fisherclassify(classify):

	def __init__(self, getfeatures):
		classify.__init__(self, getfeatures)
		self.minimums={}

	def cprob(self, f, cat):
		# The frequency of this feature in this category
		clf = self.fprob(f, cat)
		if clf == 0: return 0

		# Frequency
		freqsum = sum([self.fprob(f, c) for c in self.categories()])

		# Probaility is the frequency
		p = clf / (freqsum)
		return p
	
	def fisherprob(self, item, cat):
		print "Entering fisher prob"
		# Multiply all the probailities together
		p = 1
		features = self.getfeatures(item)
		for f in features:
			p *= (self.weightedprob(f, cat, self.cprob))
			print p

		# Take the natural log and multiply by -2
		fscore = 2 * math.log(p)

		# Use inverse chi2 function to get the probality
		def invchi2(self, chi, df):
			m = chi / 2.0
			sum = term = math.exp(-m)
			# 4 // 2 is more or less the same as int(floor(4.0/2.0))
			for i in range(1, df//2):
				term *= m / i
				sum += term
			return min(sum, 1.0)


		def setminimum(self, cat, min):
			self.minimums[cat] = min

		def getminimum(self, cat):
			if cat not in self.minimums: return 0
			return self.minimums[cat]

		def classify(self, item, default=None):
			best = default
			max = 0.0
			for c in self.categories():
				p = self.fisherprob(item, c)
				print p
				if p > self.getminimum(c) and p > max:
					best = c
					max = p
			return best
			
def sep_words(self, text):
	splitter = re.compile('\\W*')
	return [s.lower() for s in splitter(text) if s != '']

def readfile(filename):
	lines = [line for line in file(filename)]
	str_data = ''.join(lines)
	return str_data

if __name__ == '__main__':
	print "Running cluster.py"
	data = readfile("_dump_file_1.extract")
	#print data
	cl = fisherclassify(getwords)
	cl.train(data, 'good')
	print cl.fcount('manual', 'good')	
	print "Done"
