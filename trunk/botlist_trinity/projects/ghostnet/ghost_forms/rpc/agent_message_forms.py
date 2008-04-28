#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from django import newforms as forms

class EntityLinksForm(forms.Form):
  main_url = forms.CharField(label='main_url',
							 widget=forms.Textarea())
  
# end of script

