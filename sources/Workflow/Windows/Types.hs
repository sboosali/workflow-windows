{-# LANGUAGE StandaloneDeriving,  EmptyDataDecls, EmptyCase, GeneralizedNewtypeDeriving, DeriveDataTypeable, DeriveGeneric, RecordWildCards, EmptyDataDecls #-}
{-|

Uppercased types are
<https://msdn.microsoft.com/en-us/library/windows/desktop/aa383751(v=vs.85).aspx
Windows Data Types>

-}
module Workflow.Windows.Types where
import Workflow.Windows.Extra

import Foreign.CStorable
-- import Haskus.Format.Binary.Union

import Foreign
import Foreign.C.Types
import Foreign.C.String
import GHC.Exts
import Data.Ix (Ix)
--TODO foreign-var-0.1

import Prelude(error) -- partial
--import Prelude.Spiros

-- | LPCWSTR stands for "Long Pointer to Constant Wide String".
type LPCWSTR = CWString

type WCHAR_T = CWchar

type UINT = Word32 -- CUInt

type WORD = Word16

type DWORD = Word32

type SIZE_T = Word64 -- TODO ??

-- | (may overflow)
toDWORD :: (Integral a) => a -> DWORD
toDWORD = fromIntegral

-- |
-- >>> fromBOOL 0
-- True
--
-- WARNING: partial
fromBOOL :: BOOL -> Bool
fromBOOL = \case
  0 -> True
  1 -> False
  i -> error $ "{workflow-windows:Workflow.Windows.Types.fromBOOL "++ show i ++"} is out of bounds "
-- toInteger > fromInteger > \case

{-|

@
LONG
A 32-bit signed integer. The range is –2147483648 through 2147483647 decimal.
This type is declared in WinNT.h as follows:
typedef long LONG;
@

-}
type LONG = Int32

-- | @void*@
type VoidStar = Ptr ()

{-| an abstract handle to a window.

-}
-- data HWND = HWND
-- newtype HWND = HWND (Ptr ())
-- type HWND = Ptr ()
newtype HWND = HWND VoidStar

getHWND :: HWND -> VoidStar
getHWND (HWND p) = p

{-|

-}
type BOOL = CInt

{-|

see
<https://msdn.microsoft.com/en-us/library/windows/desktop/ms681381(v=vs.85).aspx
System Error Codes>

-}
newtype SystemErrorCode = SystemErrorCode DWORD
 deriving (Bounded, Enum, Eq, Integral, Data, Num, Ord, Read, Real, Show, Ix, FiniteBits, Bits, Storable)

getSystemErrorCode :: SystemErrorCode -> DWORD
getSystemErrorCode (SystemErrorCode n) = n

{-|

@
union {
  MOUSEINPUT    mi;
  KEYBDINPUT    ki;
  HARDWAREINPUT hi;
};
@

@
typedef struct tagINPUT {
  DWORD type;
  union {
    MOUSEINPUT    mi;
    KEYBDINPUT    ki;
    HARDWAREINPUT hi;
  };
} INPUT, *PINPUT;
@

<https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx>

@
allocaBytes :: Int -> (Ptr a -> IO b) -> IO b
@

TODO https://github.com/haskus/haskus-system/blob/master/src/lib/Haskus/Format/Binary/Union.hs#L69

-}
data INPUT
 = MOUSEINPUT_    MOUSEINPUT
 | KEYBDINPUT_    KEYBDINPUT
 | HARDWAREINPUT_ HARDWAREINPUT
--   deriving (Show,Read,Eq,Ord,Generic,Data)--,NFData,Semigroup,Monoid)
-- deriving instance Storable INPUT

--(Union '[Word16, Word32, Word64])

data MOUSEINPUT    = MOUSEINPUT
data KEYBDINPUT    = KEYBDINPUT
data HARDWAREINPUT = HARDWAREINPUT

-- data INPUT
--  deriving (Show,Read,Eq,Ord,Generic,Data)--,NFData,Semigroup,Monoid)
--
-- {-
--
-- mallocBytes :: Int -> IO (Ptr a)
--
-- -}
-- instance Storable POINT where
--  peek      _ =
--  poke      _ _ = return()
--  alignment _ = 4 -- TODO ??
--  sizeOf    _ = sizeof_INPUT

{-|

see
<https://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx Mouse Events>

-}
newtype MOUSEEVENTF = MOUSEEVENTF DWORD
 deriving (Bounded, Enum, Eq, Integral, Data, Num, Ord, Read, Real, Show, Ix, FiniteBits, Bits, Storable)

getMOUSEEVENTF :: MOUSEEVENTF -> DWORD
getMOUSEEVENTF (MOUSEEVENTF n) = n
-- manual accessor doesn't pollute Show instance

{-|

see
<https://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx Virtual-Key Codes>

(no display brightness, no @Fn@ modifier key).

-}
newtype VK = VK WORD
 deriving (Bounded, Enum, Eq, Integral, Data, Num, Ord, Read, Real, Show, Ix, FiniteBits, Bits, Storable)

getVK :: VK -> WORD
getVK (VK n) = n
-- manual accessor doesn't pollute Show instance

--------------------------------------------------------------------------------

-- type LPPOINT = Ptr POINT

-- type POINT =
--   ( LONG  -- x
--   , LONG  -- y
--   )
--
-- pattern POINT x y = (x,y)

-- {-|
--
-- TODO vinyl record
-- GetCursorPos
--
--  with malloc $ \p -> do
--   GetCursorPos p
--   sequence [peek p 0, peek p 4]
--
-- -}

{-|

@
struct POINT
{
    LONG  x;
    LONG  y;
}
@

-}
data POINT = POINT
 { xPOINT :: LONG
 , yPOINT :: LONG
 } deriving (Show,Read,Eq,Ord,Generic,Data)--,NFData,Semigroup,Monoid)

instance CStorable POINT
instance Storable  POINT where
 peek      = cPeek
 poke      = cPoke
 alignment = cAlignment
 sizeOf    = cSizeOf

--------------------------------------------------------------------------------

{-|

@
struct RECT
{
    LONG    left;
    LONG    top;
    LONG    right;
    LONG    bottom;
}
@

-}
data RECT = RECT
 { leftRECT   :: LONG
 , topRECT    :: LONG
 , rightRECT  :: LONG
 , bottomRECT :: LONG
 } deriving (Show,Read,Eq,Ord,Generic,Data)--,NFData,Semigroup,Monoid)

instance CStorable RECT
instance Storable  RECT where
 peek      = cPeek
 poke      = cPoke
 alignment = cAlignment
 sizeOf    = cSizeOf

-----------------------------------------------------------------------------------------

newtype Application = Application String
 deriving (Show,IsString,Read,Eq,Ord,Generic,Data)--,NFData,Semigroup,Monoid)

-- | (accessor)
getApplication :: Application -> String
getApplication (Application s) = s

newtype URL = URL String
 deriving (Show,IsString,Read,Eq,Ord,Generic,Data)--,NFData,Semigroup,Monoid)

-- | (accessor)
getURL :: URL -> String
getURL (URL s) = s

{-|

Non-unique. e.g. open two blank (chrome) browser windows, both will match:

@
Window{..}
 where
 windowExecutable = "chrome.exe"
 windowClass      = "Chrome_WidgetWin_1"
 windowTitle      = "New Tab - Google Chrome"
@

-}
data Window = Window
 { windowExecutable :: String
 , windowClass      :: String
 , windowTitle      :: String
 } deriving (Show) --TODO

-- | only the 'windowTitle'
instance IsString Window where -- TODO Maybe String? Vinyl? Rec Id and Rec Maybe.
 fromString = aWindowTitle

aWindowExecutable :: String -> Window
aWindowExecutable s = Window{..}
  where
  windowExecutable = s
  windowClass      = ""
  windowTitle      = ""

aWindowClass :: String -> Window
aWindowClass s = Window{..}
  where
  windowExecutable = ""
  windowClass      = s
  windowTitle      = ""

aWindowTitle :: String -> Window
aWindowTitle s = Window{..}
  where
  windowExecutable = ""
  windowClass      = ""
  windowTitle      = s

-----------------------------------------------------------------------------------------
