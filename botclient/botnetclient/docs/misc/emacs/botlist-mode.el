;;************************************************
;; Berlin Brown - berlin.brown at gmail.com
;;
;; Add the following to your .emacs config file
;; (load-file "~/lib/emacs/botlist-mode.el")
;;************************************************

(defgroup botlist nil
  "Botlist mode"
  :group 'languages)

;;************************************************
;; Editable Definitions
;;************************************************
(defvar botlist-current-test "~/lib/emacs/botlist.bin")

(setq botlist-current-test 
	  "c:\\projects\\tools\\home\\projects\\projects_ecl\\botlist_testserver\\lib\\run_tests_loadtest.pl")

(defvar botlist-mode-map (make-sparse-keymap))

(defun botlist-run-file ()
  (interactive)
  (insert "Hello World\n"))

;;************************************************
;; Associate the following keystrokes with the according action.
;;************************************************
(define-key botlist-mode-map "\C-cc" 'botlist-run-file)

(defcustom botlist-mode-hook nil
  "Hook run when entering Botlist mode."
  :type 'hook
  :group 'botlist)
  
;;************************************************
;; End of Process Helpers
;;************************************************

(define-derived-mode botlist-test-listener-mode 
  comint-mode "Botlist Test Listener")

(defun run-botlist-current-test ()
  (interactive)
  (switch-to-buffer
   (make-comint-in-buffer "botlist" nil "perl" nil
						  botlist-current-test ""))
  (botlist-test-listener-mode))

(defun botlist-mode ()
  "A mode for working with developer and test programs written the botlist application."
  (interactive)
  (pop-to-buffer "*Botlist*" nil)
  (kill-all-local-variables)
  (use-local-map botlist-mode-map)
  (setq major-mode 'botlist-mode)
  (setq mode-name "Botlist")
  (run-hooks 'botlist-mode-hook))

(require 'comint)

;;************************************************
;; End of Script
;;************************************************

