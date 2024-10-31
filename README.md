# Habit Tracker Smart Contract

## Overview
This smart contract is designed for a habit tracker application built on the Stacks blockchain using the Clarity programming language. The contract allows users to create, log, retrieve, and reset habits while also tracking their progress and rewards.

## Features
- **Create Habits:** Users can create new habits with specified frequencies.
- **Log Habits:** Users can log their daily progress for each habit.
- **Retrieve Habit Details:** Users can fetch the details of their habits.
- **Check Reward Points:** Users can view the total reward points earned for completing habits.
- **Reset Habits:** Users can reset their habits, clearing the tracking data.

## Data Structure
The contract uses a map to store habits for each user, with the following structure:
```clarity
(define-data-var habits (map (tuple (user principal) (habit-name (string))) 
                              (tuple (frequency (uint)) 
                                     (completed (bool)) 
                                     (last-logged (uint)) 
                                     (streak (uint)) 
                                     (reward-points (uint)))))
