#!/usr/bin/env zsh
#
# How to use:
#   1. Save this file locally and import it by adding ". ~/rl.sh" to ~/.zshrc file.
#       If .zshrc doesn't exist, create it in your ~ folder (/Users/[username]) via the command "touch ~/.zshrc"
#   2. Type and enter "rl" ('R'ecovery Version 'L'ookup) followed by the verse reference (ex. "rl John 1:1" or "rl John 1 1") into the terminal
#      console to navigate to that verse in the app Holy Bible (Recovery Version).
#       You can also copy the reference (into the clipboard) and simply type and enter "rl" into the terminal console.
#      Alternatively, you can replace "rl" to "rw" ('R'ecovery Version 'W'ebsite) to open the text through a browser instead.
#
# The following arrays were originally created for BibleHub navigation, which is why it's not optimized for RcV app

typeset -A biblebooks
local biblebooks=([gen]=genesis [exo]=exodus [lev]=leviticus [num]=numbers [deu]=deuteronomy [jos]=joshua [jdg]=judges [rut]=ruth
  [1sa]=1_samuel [2sa]=2_samuel [1ki]=1_kings [2ki]=2_kings [1ch]=1_chronicles [2ch]=2_chronicles [ezr]=ezra [neh]=nehemiah
  [est]=esther [job]=job [psa]=psalms [pro]=proverbs [ecc]=ecclesiastes [son]=song_of_songs [sos]=song_of_songs
  [s.s]=song_of_songs [s.]=song_of_songs [ss]=song_of_songs [isa]=isaiah
  [jer]=jeremiah [lam]=lamentations [eze]=ezekiel [dan]=daniel [hos]=hosea [joe]=joel [amo]=amos [oba]=obadiah [jon]=jonah
  [mic]=micah [nah]=nahum [hab]=habakkuk [zep]=zephaniah [hag]=haggai [zec]=zechariah [mal]=malachi [mat]=matthew [mar]=mark
  [luk]=luke [joh]=john [act]=acts [rom]=romans [1co]=1_corinthians [2co]=2_corinthians [gal]=galatians [eph]=ephesians
  [phi]=philippians [col]=colossians [1th]=1_thessalonians [2th]=2_thessalonians [1ti]=1_timothy [2ti]=2_timothy [tit]=titus
  [phm]=philemon [heb]=hebrews [jam]=james [1pe]=1_peter [2pe]=2_peter [1jo]=1_john [2jo]=2_john [3jo]=3_john [jud]=jude
  [rev]=revelation)

typeset -A biblebooknumber
local biblebooknumber=([genesis]=01 [exodus]=02 [leviticus]=03 [numbers]=04 [deuteronomy]=05 [joshua]=06 [judges]=07 [ruth]=08
  [1_samuel]=09 [2_samuel]=10 [1_kings]=11 [2_kings]=12 [1_chronicles]=13 [2_chronicles]=14 [ezra]=15 [nehemiah]=16
  [esther]=17 [job]=18 [psalms]=19 [proverbs]=20 [ecclesiastes]=21 [song_of_songs]=22 [isaiah]=23
  [jeremiah]=24 [lamentations]=25 [ezekiel]=26 [daniel]=27 [hosea]=28 [joel]=29 [amos]=30 [obadiah]=31 [jonah]=32
  [micah]=33 [nahum]=34 [habakkuk]=35 [zephaniah]=36 [haggai]=37 [zechariah]=38 [malachi]=39 [matthew]=40 [mark]=41
  [luke]=42 [john]=43 [acts]=44 [romans]=45 [1_corinthians]=46 [2_corinthians]=47 [galatians]=48 [ephesians]=49
  [philippians]=50 [colossians]=51 [1_thessalonians]=52 [2_thessalonians]=53 [1_timothy]=54 [2_timothy]=55 [titus]=56
  [philemon]=57 [hebrews]=58 [james]=59 [1_peter]=60 [2_peter]=61 [1_john]=62 [2_john]=63 [3_john]=64 [jude]=65
  [revelation]=66)

ref_fy () {
  local num='^[1-3]$';
  local nums='^[0-9]*$';
  local chpver='^[1-9]+[0-9]*:[1-9]+[0-9]*$';
  local index=1;
  local rec=0;

  local refs=($@);
  if [[ "$refs" = '' || "$refs" = 'r' ]]; then # Search
    refs=($refs $(pbpaste));
  fi

  if [[ $refs[$index] = 'r' ]]; then # Recovery Version reference
    ((index++));
    rec=1;
  fi

  if [[ ${refs[$index]:l} = 'song' ]]; then # song of songs
    ((index+=2))
  elif [[ ${refs[$index]:l} = 's.' ]]; then # s. s.
    ((index++))
  fi

  # If reference starts with numeric
  if [[ $refs[$index] =~ $num ]]; then
    local book_name="$refs[$index]$refs[$index+1]";
  else
    ((index--));
    local book_name=$refs[$index+1];
  fi

  # Parse input reference to book_name (lowercase, no space), book_n (retrieved from array), chp (number), ver (number)
  if [[ $refs[$index+2] =~ $chpver ]]; then
    local cv=$refs[$index+2];
    local chp=${cv%:*};
    local ver=${cv#*:};
  else
    local chp=$refs[$index+2];
    local ver=$refs[$index+3];
  fi

  if [[ $chp = '' ]]; then
    chp=1
  fi

  # Check for invalid references (non-numeric chapter and verse)
  if ! [[ $chp =~ $nums && $ver =~ $nums ]]; then
    print '-1'
  else
    book_name=${book_name:l};
    local book3=${book_name[1,3]};
    local book_n=$biblebooks[$book3];

    if [[ "${book_name[1,6]}" = 'philem' || "${book_name[1,5]}" = 'philm' ]]; then
      book_n=philemon
    elif [[ "${book_name[1,4]}" = 'judg' || "${book_name[1,3]}" = 'jdg' ]]; then
      book_n=judges
    fi

    # Format short book name
    local book_num=$biblebooknumber[$book_n];
    if [[ $book3[1] = 1 ]]; then
      local book_short_r=F${book3[2]:u}${book3[3]:l};
    elif [[ $book3[1] = 2 ]]; then
      local book_short_r=S${book3[2]:u}${book3[3]:l};
    elif [[ $book3[1] = 3 ]]; then
      local book_short_r=T${book3[2]:u}${book3[3]:l};
    else
      local book_short_r=${book3[1]:u}${book3[2,3]:l};
    fi
    # Format full book name
    local book_parts=(${(s/_/)book_n});
    if [[ "$book_parts[1]" =~ $num ]]; then
      local book_name_r=$book_parts[1]${book_parts[2][1]:u}${book_parts[2][2,-1]:l}
    elif [[ "$book_parts[1]" = song ]]; then
      local book_name_r=SongofSongs;
      book_short_r=Son;
    elif [[ "$book_parts[1]" = philemon ]]; then
      local book_name_r=Philemon;
      book_short_r=Phm;
    elif [[ "$book_parts[1]" = jude ]]; then
      local book_name_r=Jude;
      book_short_r=Jde;
    elif [[ "$book_parts[1]" = judges ]]; then
      local book_name_r=Judges;
      book_short_r=Jud;
    else
      local book_name_r=${book_parts[1][1]:u}${book_parts[1][2,-1]:l}
    fi
    if [[ $ver = '' ]]; then
      if [[ $book_short_r = Oba || $book_short_r = Phm || $book_short_r = SJo || $book_short_r = TJo|| $book_short_r = Jde ]]; then
        print "$book_num"_"$book_name_r"_"1.htm#$book_short_r"1-"$chp";
      else
        print "$book_num"_"$book_name_r"_"$chp.htm#$book_short_r$chp-1";
      fi
    else
      print "$book_num"_"$book_name_r"_"$chp.htm#$book_short_r$chp-$ver";
    fi
  fi
}

rl() {
  local refs=$(ref_fy r $@);
  # Redirects first to Psalm 117 (the shortest chapter in the Bible) in case the new reference is the chapter as the previous reference.
  # Otherwise the app will not redirect to a different verse within the same chapter.
  open -a Holy\ Bible "https://text.recoveryversion.bible/19_Psalms_117.htm#Psa117";
  # it will not relocate to a new different verse
  open -a Holy\ Bible "https://text.recoveryversion.bible/$refs";
}

rw() {
  local refs=$(ref_fy r $@);
  open "https://text.recoveryversion.bible/$refs";
}

# Customize with desired alias. Replace "bibleapp" or "bibleonline" with any desired word (e.g. alias an_alias=rl)
alias bibleapp=rl
alias bibleonline=rw
