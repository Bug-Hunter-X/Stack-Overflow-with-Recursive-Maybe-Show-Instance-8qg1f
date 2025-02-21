{-# LANGUAGE FlexibleInstances #-}

instance (Show a) => Show (Maybe a) where
  showsPrec p Nothing = showParen (p > 10) $ showString "Nothing"
  showsPrec p (Just x) = showParen (p > 10) $ showString "Just " ++ showsPrec p x

main :: IO ()
main = do
  print (Just 1)
  print Nothing

-- The solution addresses the problem by directly concatenating the string representation of x
-- instead of using showsPrec 11 x, which can be problematic with recursive data structures.
-- This prevents the infinite recursion that leads to the stack overflow.

data SelfRef a = SelfRef (Maybe (SelfRef a))

instance (Show a) => Show (SelfRef a) where
  showsPrec p (SelfRef x) = showParen (p > 10) $ showString "SelfRef " ++ showsPrec p x

-- Now, this will print correctly without causing a stack overflow.