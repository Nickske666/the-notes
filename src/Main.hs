{-# LANGUAGE QuasiQuotes #-}
module Main where

import           Prelude                                 as P

import qualified Data.Text                               as T
import qualified Data.Text.IO                            as T

import           Control.Monad                           (unless, when)
import           Control.Monad.Reader                    (MonadReader (..),
                                                          asks)
import           Data.List                               (intercalate)
import           System.Exit                             (ExitCode (..), die)
import           System.Process                          (CreateProcess (..), readCreateProcessWithExitCode,
                                                          shell)
import           Text.Regex.PCRE.Heavy                   (re, scan)

import           Notes
import           Utils

import           Header
import           Packages
import           Parser
import           Titlepage

import           Computability.Main
import           DataMining.Main
import           Fields.Main
import           Functions.Main
import           Groups.Main
import           LinearAlgebra.Main
import           Logic.Main
import           MachineLearning.Main
import           Probability.Main
import           Relations.Main
import           Rings.Main
import           Sets.Main
import           Topology.Main

import           Text.LaTeX.LambdaTeX.Reference.Internal (renderReferences)


main :: IO ()
main = do
    mc <- getConfig
    case mc of
      Nothing -> error "Couldn't parse arguments."
      Just cf -> do
        let mainBibFile = conf_bibFileName cf ++ ".bib"
            mainTexFile = conf_texFileName cf ++ ".tex"
            mainPdfFile = conf_pdfFileName cf ++ ".pdf"
        removeIfExists mainBibFile
        let gconf = defaultGenerationConfig { generationSelection = conf_selection cf }
        (eet, _) <- runNote entireDocument cf gconf startState
        case eet of
            Left err -> error err
            Right (t, refs) -> do

                renderFile mainTexFile t

                T.appendFile mainBibFile $ renderReferences refs

                (ec, out, err) <- liftIO $ readCreateProcessWithExitCode (latexMkJob cf) ""
                let outputAnyway = do
                      putStrLn out
                      putStrLn err
                case ec of
                  ExitFailure _ -> do
                      outputAnyway
                      die "Compilation failed"
                  ExitSuccess -> do
                      if (P.not $ conf_ignoreReferenceErrors cf) && (containsRefErrors $ out ++ "\n" ++ err)
                      then do
                          removeIfExists mainPdfFile
                          outputAnyway
                          die "Undefined references"
                      else when (conf_verbose cf) outputAnyway

        return ()

containsRefErrors :: String -> Bool
containsRefErrors s = (P.> 2) $ P.length $ scan [re|There were undefined references.|] s

latexMkJob :: Config -> CreateProcess
latexMkJob cf = shell $ "latexmk " ++ unwords latexMkArgs
  where
    mainTexFile :: FilePath
    mainTexFile = conf_texFileName cf ++ ".tex"

    latexMkArgs :: [String]
    latexMkArgs = ["-pdf", pdfLatexArg, jobNameArg, mainTexFile]

    jobNameArg :: String
    jobNameArg = "-jobname=" ++ conf_pdfFileName cf

    pdfLatexArg :: String
    pdfLatexArg = "-pdflatex='" ++ pdfLatexCmd ++ "'"

    pdfLatexCmd :: String
    pdfLatexCmd = "pdflatex " ++ unwords pdfLatexArgs

    pdfLatexArgs :: [String]
    pdfLatexArgs = ["-shell-escape", "-halt-on-error", "-enable-write18"]


startState :: State
startState = State

renderConfig :: Note
renderConfig = do
  vspace $ Cm 1
  conf <- ask
  "The code for this pdf was generated by running the `the notes' generator with the following configuration."
  verbatim $ T.pack $ breakUp $ show conf
  raw "\n"
  newpage

breakUp :: String -> String
breakUp = intercalate "\n" . chunk 80

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = y1 : chunk n y2
  where (y1, y2) = splitAt n xs


entireDocument :: Note
entireDocument = do
  documentclass [oneside, a4paper] book

  packages
  makeindex
  header

  document $ do
    myTitlePage
    tableofcontents
    newpage
    renderConfig
    allNotes

    bibfn <- asks conf_bibFileName
    comm1 "bibliographystyle" "plain"
    comm1 "bibliography" $ raw $ T.pack bibfn

    printindex

    o <- asks conf_omitTodos
    unless o $ comm0 "listoftodos"



allNotes :: Note
allNotes = do
    logica
    sets
    relations
    functions
    groups
    rings
    fields
    linearAlgebra
    topology
    computability
    probability
    machineLearning
    dataMining
