
# default rule
default: all
# phony rules

validate: 
	cfn-lint validate cloudformation/g2s.yaml

apply:
	cim stack-up cloudformation/
