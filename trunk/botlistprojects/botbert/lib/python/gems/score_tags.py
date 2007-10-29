"""
 score_tags.py
"""

class ScoreTagHandler:
	
	def __init__(self):
		self.terms_dict = { }
		self.tags_score = { }
		self.keywords = None
		self.top_group = None
		
	def resetGroupScores(self):
		for term_key in self.terms_dict.keys():
			self.tags_score[term_key] = 0
	
	def findAndRateTerms(self, terms_list, group_set, keyword):
		""" Actually rate a particular group, term for 'politics' may include 'congress' """
		for term in terms_list:
			if term == keyword:
				self.tags_score[group_set] =  self.tags_score[group_set] + 1
				
	def scoreTerms(self):
		""" Iterate through the list of keywords and score them if a value is found """
		keywords_list = self.keywords.split()
		for keyword in keywords_list:
			# If a keyword is found in a particular group set, increment the score
			for group_set_name in self.terms_dict.keys():
				# an example group_set may include 'politics'				
				self.findAndRateTerms(self.terms_dict[group_set_name], group_set_name, keyword)
		
		# Score all the terms and set the final result (find the max)
		score_max = 0
		for group_key in self.tags_score.keys():
			if self.tags_score[group_key] > score_max:
				self.top_group = group_key
				score_max = self.tags_score[group_key]
				
		return self.top_group
				
# End of the script