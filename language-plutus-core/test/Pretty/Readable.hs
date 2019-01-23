module Pretty.Readable (test_Pretty) where

import           Language.PlutusCore.FsTree              (foldPlcFolderContents)
import           Language.PlutusCore.Pretty
import           Language.PlutusCore.Quote

import           Language.PlutusCore.Examples.Everything (examples)
import           Language.PlutusCore.StdLib.Everything   (stdLib)

import           Common

import           Test.Tasty

prettyConfigReadable :: PrettyConfigPlc
prettyConfigReadable
    = PrettyConfigPlc defPrettyConfigPlcOptions
    . PrettyConfigPlcReadable
    $ botPrettyConfigReadable defPrettyConfigName ShowKindsYes

testReadable :: PrettyPlc a => TestName -> Quote a -> TestNested
testReadable name = nestedGoldenVsDoc name . prettyBy prettyConfigReadable . runQuote

test_PrettyReadable :: FilePath -> TestTree
test_PrettyReadable testDir
    = runTestNestedIn [testDir, "test", "Pretty", "Golden"]
    . testNested "Readable"
    . foldPlcFolderContents testNested testReadable testReadable
    $ stdLib <> examples

test_Pretty :: FilePath -> TestTree
test_Pretty testDir =
    testGroup "pretty"
        [ test_PrettyReadable testDir
        ]
