#!/bin/bash
LANG=C exec /usr/bin/sed -i -e 's@\(\x0C\x00\x00\x00\x4C\x00\x00\x00\x18\x00\x00\x00\x02\x00\x00\x00\)\x00...\(\x00\x00\x01\x00/System/Library/Frameworks/UIKit.framework/UIKit\x00\x00\x00\x00\)@\1\x00\x00\xF6\x0C\2@' "$1"
