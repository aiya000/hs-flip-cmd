{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Control.Exception.Safe (MonadCatch, SomeException, catch)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.Process (callCommand)

main :: IO ()
main = suppressErrMsg body
  where
    catch' :: MonadCatch m => m a -> (SomeException -> m a) -> m a
    catch' = catch

    suppressErrMsg :: IO () -> IO ()
    suppressErrMsg m = m `catch'` const exitFailure

    body :: IO ()
    body = getArgs >>= \case
      (cmd:x1:x2:xs) -> callCommand $ unwords (cmd:x2:x1:xs)
      xs             -> callCommand $ unwords xs
