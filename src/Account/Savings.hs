module Account.Savings where

import Account.Classes
import Aliases
import Data.DateTime

data SavingsAccount = SavingsAccount
  { sId :: String
  , sName :: String
  , sBalance :: Amount
  , sInterestRate :: InterestRate
  , sDateOpen :: DateTime
  , sDateClosed :: Maybe DateTime
  }

instance Show SavingsAccount where
  show (SavingsAccount i n b _ _ _) = i ++ " - " ++ n ++ ": $" ++ (show b)

instance Account SavingsAccount where
  accountId = sId
  name = sName
  balance = sBalance
  isOpen account
    | sDateClosed account == Nothing = True
    | otherwise = False
  credit account amount
    | isClosed account = Left AccountClosed
    | otherwise = Right $ account {sBalance = (balance account) + amount}
  debit account amount
    | isClosed account = Left AccountClosed
    | balance account < amount = Left InsufficientFunds
    | otherwise = Right $ account {sBalance = (balance account) - amount}
  close account when
    | isClosed account = Left AccountClosed
    | otherwise = Right $ account {sDateClosed = Just when}

instance InterestBearingAccount SavingsAccount where
  interestRate = sInterestRate