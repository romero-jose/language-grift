{-# LANGUAGE ExplicitForAll #-}

module Language.Grift.Source.Utils
  ( bottomUp
  , cata
  , getFst
  , getSnd
  , stripSnd
  ) where

import           Data.Monoid           (Sum (..))

import           Language.Grift.Source.Syntax


cata :: forall a b f. Functor f => (b -> f a -> a) -> Ann b f -> a  
cata f (Ann a e) = f a $ fmap (cata f) e

bottomUp :: forall a b e. Functor e => (a -> e (Ann b e) -> b) -> Ann a e -> Ann b e
bottomUp fn = cata (\a e -> Ann (fn a e) e)

getSnd :: forall a e. Ann (a, Sum Int) e -> Sum Int
getSnd (Ann (_, n) _) = n

getFst :: forall a b. Ann (a, b) Type -> a
getFst (Ann (a,_) _) = a

stripSnd :: Ann (a, b) Type -> Ann a Type
stripSnd (Ann (a, _) t) = Ann a $ stripSnd <$> t