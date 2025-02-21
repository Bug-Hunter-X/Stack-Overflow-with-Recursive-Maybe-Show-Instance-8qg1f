{-# LANGUAGE FlexibleInstances #-}

instance (Show a) => Show (Maybe a) where
  showsPrec p Nothing = showParen (p > 10) $ showString "Nothing"
  showsPrec p (Just x) = showParen (p > 10) $ showString "Just " . showsPrec 11 x

main :: IO ()
main = do
  print (Just 1)
  print Nothing

-- This code compiles and runs fine. However, it has a subtle bug.
-- The problem lies in the implementation of the Show instance for Maybe a.
-- Specifically, the line `showParen (p > 10) $ showString "Just " . showsPrec 11 x` uses `showsPrec 11 x` which doesn't handle the case where `x` is a recursive data structure that contains itself.
-- This can lead to stack overflow if a `Maybe` contains a value that recursively references itself.

-- For instance, consider the following data structure:

data SelfRef a = SelfRef (Maybe (SelfRef a))

instance (Show a) => Show (SelfRef a) where
  showsPrec p (SelfRef x) = showParen (p > 10) $ showString "SelfRef " . showsPrec 11 x

-- If we try to print `Just (SelfRef (Just (SelfRef (Just ...))))`, it will cause a stack overflow.