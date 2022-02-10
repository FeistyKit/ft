import Distribution.Compat.Directory (listDirectory)
import System.Environment
import System.Posix

dirToString :: String -> IO String
dirToString a = unwords . map show <$> listDirectory a

data DirEntry = File String | Dir String [DirEntry] deriving (Show)

entriesOfDir :: FilePath -> IO [DirEntry]
entriesOfDir path = mapM (makeEntry . (fullPath ++)) =<< listDirectory path
  where
    makeEntry :: FilePath -> IO DirEntry
    makeEntry path = do
      status <- getFileStatus path
      if isDirectory status
        then do
          entries <- entriesOfDir path
          return $ Dir path entries
        else return $ File path
    fullPath :: String
    fullPath = path ++ "/"

usage :: String
usage = "USAGE: ./ft <dir to list>"

-- TODO: Check if input is a directory
argsValid :: [String] -> IO Bool
argsValid [x] = isDirectory <$> getFileStatus x
argsValid _ = return False

handleInput :: [String] -> IO String
handleInput a = do
  valid <- argsValid a
  if valid then dirToString $ head a else return usage

main :: IO ()
main = getArgs >>= handleInput >>= putStrLn
