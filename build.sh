#!/bin/sh

gmake package 
gmake package PLATFORM=iphoneos SCHEME="'Vencord Web (iOS)'"
