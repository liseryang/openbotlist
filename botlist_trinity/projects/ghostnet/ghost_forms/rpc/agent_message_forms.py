#!/usr/bin/env python
#
# Copyright 2008 Berlin Brown - botnode.com.

from django import newforms as forms

class AgentMessageForm(forms.Form):
  types_payload = forms.CharField(label='types_payload',
                                  widget=forms.Textarea())
  
# end of script

