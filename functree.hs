import Distribution.Compat.Directory (listDirectory)
import System.Environment

dirToString :: String -> IO String
dirToString a = unwords . map show <$> listDirectory a

usage :: String
usage = "USAGE: ./ft <dir to list>"

-- TODO: Check if input is a directory
parseArgs :: [String] -> String
parseArgs [name] = name
parseArgs _ = usage

main :: IO ()
main = getArgs >>= dirToString . parseArgs >>= putStrLn
