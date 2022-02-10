import Distribution.Compat.Directory (listDirectory)
import System.Environment
import System.Posix

dirToString :: String -> IO String
dirToString a = unwords . map show <$> listDirectory a

data DirEntry = File String | Dir String [DirEntry] deriving (Show, Eq)

strMul :: Integer -> String -> String
strMul 0 s = s
strMul x s = strMul (x - 1) s ++ s

pushTogether :: [Integer] -> String -> String
pushTogether [l] s = "|" ++ strMul (l - 1) "-" ++ s
pushTogether (x : xs) s = "|" ++ strMul (x - 1) " " ++ pushTogether xs s
pushTogether _ _ = ""

entryToString :: [Integer] -> DirEntry -> String
entryToString x (File name) = pushTogether x name
entryToString x (Dir name entries) = if null entries then pushTogether x name else pushTogether x name ++ "\n" ++ subItems
  where
    nameLen = [toInteger $ length name]
    subItems = unlines (map (entryToString (x ++ nameLen)) entries)

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

argsValid :: [String] -> IO Bool
argsValid [x] = isDirectory <$> getFileStatus x
argsValid _ = return False

handleInput :: [String] -> IO String
handleInput a = do
  valid <- argsValid a
  if valid then dirToString $ head a else return usage

main :: IO ()
main = getArgs >>= handleInput >>= putStrLn
