(define-data-var habits (map (tuple (user principal) (habit-name (string))) (tuple (frequency (uint) ) (completed (bool) ) (last-logged (uint)) (streak (uint)) (reward-points (uint))))) ; Store user habits with frequency, completion status, last logged day, streak count, and reward points.

(define-public (create-habit (habit-name (string)) (frequency (uint)))
  (begin
    (if (is-err (map-set habits (tuple (user (get-caller)) (habit-name habit-name)) (tuple (frequency frequency) (completed false) (last-logged 0) (streak 0) (reward-points 0))))
      (err "Habit creation failed")
      (ok "Habit created successfully"))))

(define-public (log-habit (habit-name (string)))
  (let ((user (get-caller)))
    (let ((habit (map-get habits (tuple (user user) (habit-name habit-name)))))
      (if (is-none habit)
        (err "Habit not found")
        (let* ((habit-details (unwrap habit))
               (frequency (get frequency habit-details))
               (completed (get completed habit-details))
               (last-logged (get last-logged habit-details))
               (current-day (as-max uint (block-height))) ; Use block height as a day counter
               (new-completed (if (= last-logged current-day) true false))
               (new-streak (if (= new-completed true) (+ (get streak habit-details) 1) 0))
               (reward-points (if (= new-completed true) (+ (get reward-points habit-details) 10) (get reward-points habit-details))))
          (map-set habits (tuple (user user) (habit-name habit-name))
                   (tuple (frequency frequency) (completed new-completed) (last-logged current-day) (streak new-streak) (reward-points reward-points)))
          (ok "Habit logged successfully")))))))

(define-public (get-habit (habit-name (string)))
  (let ((user (get-caller)))
    (let ((habit (map-get habits (tuple (user user) (habit-name habit-name)))))
      (if (is-none habit)
        (err "Habit not found")
        (ok (unwrap habit))))))

(define-public (get-reward-points (habit-name (string)))
  (let ((user (get-caller)))
    (let ((habit (map-get habits (tuple (user user) (habit-name habit-name)))))
      (if (is-none habit)
        (err "Habit not found")
        (ok (get reward-points (unwrap habit)))))))

(define-public (reset-habit (habit-name (string)))
  (let ((user (get-caller)))
    (let ((habit (map-get habits (tuple (user user) (habit-name habit-name)))))
      (if (is-none habit)
        (err "Habit not found")
        (begin
          (map-set habits (tuple (user user) (habit-name habit-name))
                   (tuple (frequency (get frequency (unwrap habit))) (completed false) (last-logged 0) (streak 0) (reward-points 0)))
          (ok "Habit reset successfully")))))))

