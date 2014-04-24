{-# LANGUAGE CPP, TemplateHaskell, KindSignatures, PolyKinds, TypeOperators,
             DataKinds, ScopedTypeVariables, TypeFamilies, GADTs,
             UndecidableInstances #-}
#if __GLASGOW_HASKELL__ >= 707
{-# LANGUAGE AllowAmbiguousTypes #-}   -- GHC #9019
#endif

-----------------------------------------------------------------------------
-- |
-- Module      :  Data.Singletons.Prelude.Base
-- Copyright   :  (C) 2014 Jan Stolarek
-- License     :  BSD-style (see LICENSE)
-- Maintainer  :  Jan Stolarek (jan.stolarek@p.lodz.pl)
-- Stability   :  experimental
-- Portability :  non-portable
--
-- Implements singletonized functions from GHC.Base module.
--
----------------------------------------------------------------------------

module Data.Singletons.Prelude.Base (
  Foldr, sFoldr, Map, sMap, (:++), (%:++), Otherwise, sOtherwise,
  Id, sId, Const, sConst, (:.), (%:.), Flip, sFlip, AsTypeOf, sAsTypeOf,
  Seq, sSeq,

  -- * Defunctionalization symbols
  FoldrSym0, FoldrSym1, FoldrSym2, FoldrSym3,
  MapSym0, MapSym1, MapSym2,
  (:++$), (:++$$),
  OtherwiseSym0,
  IdSym0, IdSym1,
  ConstSym0, ConstSym1, ConstSym2,
  (:.$), (:.$$), (:.$$$),
  FlipSym0, FlipSym1, FlipSym2,
  AsTypeOfSym0, AsTypeOfSym1, AsTypeOfSym2,
  SeqSym0, SeqSym1, SeqSym2
  ) where

import Data.Singletons.Prelude.Instances
import Data.Singletons.TH
import Data.Singletons.Prelude.Bool

-- Promoted and singletonized versions of "otherwise" are imported and
-- re-exported from Data.Singletons.Prelude.Bool. This is done to avoid cyclic
-- module dependencies.

$(singletonsOnly [d|
  foldr                   :: (a -> b -> b) -> b -> [a] -> b
  -- Temporalily eta-expanded to work around #31
  foldr k z n = go n
            where
              go []     = z
              go (y:ys) = y `k` go ys

  map                     :: (a -> b) -> [a] -> [b]
  map _ []                = []
  map f (x:xs)            = f x : map f xs

  (++)                    :: [a] -> [a] -> [a]
  (++) []     ys          = ys
  (++) (x:xs) ys          = x : xs ++ ys

  id                      :: a -> a
  id x                    =  x

  const                   :: a -> b -> a
  const x _               =  x

  (.)    :: (b -> c) -> (a -> b) -> a -> c
  (.) f g = \x -> f (g x)

  flip                    :: (a -> b -> c) -> b -> a -> c
  flip f x y              =  f y x

  asTypeOf                :: a -> a -> a
  -- Temporalily eta-expanded to work around #31
  asTypeOf a b            =  const a b

  -- This is not part of GHC.Base, but we need to emulate seq and this is a good
  -- place to do it.
  seq :: a -> b -> b
  seq _ x = x
 |])