--
-- DocumentRules.hs
--
-- Possibly consider introduction of lisp dialect.
--
-- Description:
-- Use the following rules to assess the value of a page.
module Data.SpiderNet.DocumentRules (checkRules) where

-- Rule: negate if tokens are less than 90
ruleTokens :: Double -> Boolean
ruleTokens val = not (val < 90)

-- Rule: negate if doc density outside of 0.4 and 0.95
ruleDocDensity :: Double -> Boolean
ruleDocDensity val = not ((val < 0.4) && (val > 0.95))

-- Rule: negate if value is zero or greater than .2
ruleStopDensity :: Double -> Boolean
ruleStopDensity val = not ((val == 0) || (val > 0.2))

-- Rule: must have at least 4 links
ruleLinks :: Double -> Boolean
ruleLinks val = not (val <= 4)

ruleDivs :: Double -> Boolean
ruleDivs val = not (val > 1)

ruleParagraph :: Double -> Boolean
ruleParagraph = not (val > 2)

defaultRuleCheck :: Double -> Boolean
defaultRuleCheck = True

docRulesMap :: Double -> Boolean
docRulesMap = [
]

checkRules :: Boolean
