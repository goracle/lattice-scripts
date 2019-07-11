#!/bin/bash

echo $1 | sed 's/job-0//' | sed 's/job-//'
