;; planet-pledge.clar
;; A micro public-goods pledge registry.
;; Anyone can pledge an amount (no STX transfer here - just a transparent commitment).
;; Read-only functions let anyone verify totals.

(define-data-var total-pledged uint u0)
(define-map pledges principal uint)

(define-constant ERR-INVALID-AMOUNT u100)

(define-public (pledge (amount uint))
  (begin
    (asserts! (> amount u0) (err ERR-INVALID-AMOUNT))
    (let (
      (current (default-to u0 (map-get? pledges tx-sender)))
      (updated (+ current amount))
    )
      (map-set pledges tx-sender updated)
      (var-set total-pledged (+ (var-get total-pledged) amount))
      (ok updated)
    )
  )
)

(define-read-only (get-pledge (who principal))
  (ok (default-to u0 (map-get? pledges who)))
)

(define-read-only (get-total)
  (ok (var-get total-pledged))
)
