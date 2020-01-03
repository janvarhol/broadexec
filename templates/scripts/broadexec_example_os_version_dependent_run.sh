#!/bin/bash

# This file is part of Broadexec.
#
# Broadexec is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Broadexec is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Broadexec.  If not, see <https://www.gnu.org/licenses/>.

BRDEXEC_SUPPORTED_OS="sles"
BRDEXEC_SUPPORTED_OS_VERSION_MIN[sles]=10.4
BRDEXEC_SUPPORTED_OS_VERSION_MAX[sles]=11.3

osrelease_check

uptime
