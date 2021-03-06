(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(add-to-list 'load-path (expand-file-name "el-get/el-get" user-emacs-directory))

(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (end-of-buffer)
    (eval-print-last-sexp)))

;; set local recipes
(setq
 el-get-sources
 '((:name evil
	  :after (lambda ()
                   (setcdr evil-insert-state-map nil)
		   (define-key evil-normal-state-map (kbd "<return>") 'evil-next-line)
		   (define-key evil-normal-state-map (kbd "C-SPC") 'evil-normal-state)
		   (define-key evil-insert-state-map (kbd "C-SPC") 'evil-normal-state)
		   (define-key evil-replace-state-map (kbd "C-SPC") 'evil-normal-state)
		   (define-key evil-insert-state-map (kbd "C-h") 'backward-delete-char-untabify)
		   (evil-mode 1))
	  :depends nil)
   (:name smex				; a better (ido like) M-x
	  :after (lambda ()
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (define-key global-map (kbd "M-x") 'smex)
		   (define-key global-map (kbd "M-X") 'smex-major-mode-commands)))
   (:name magit				; git meet emacs, and a binding
	  :after (lambda ()
		   (define-key global-map (kbd "C-x C-z") 'magit-status)))
   (:name monky
       :type git
       :url "https://github.com/ananthakumaran/monky.git")
   (:name color-theme-solarized
	  :after (lambda ()
		   (color-theme-solarized-light)))
   (:name python)
   (:name zencoding-mode)
   (:name virtualenv)
   (:name textmate
          :after (lambda ()
                   ;; I prefer using meta-t for the textmate-stuff
                   (add-hook 'textmate-mode-hook
                             '(lambda ()
                                (add-to-list '*textmate-project-roots* ".bzr")
                                (add-to-list '*textmate-project-roots* "pom.xml")
                                (define-key *textmate-mode-map* [(ctrl \;)] 'textmate-goto-file)))
                   (textmate-mode)))
   (:name flymake-point)
   (:name ace-jump-mode
          :after (lambda ()
                   (define-key global-map (kbd "C-x x") 'ace-jump-mode)))
   (:name auto-complete)
   (:name auto-complete-css)
   (:name auto-complete-etags)
   (:name auto-complete-yasnippet)
   (:name vcl-mode
          :url "https://www.varnish-cache.org/svn/trunk/varnish-tools/emacs/vcl-mode.el")
   (:name ac-slime)
   (:name paredit)
   (:name textile-mode)
   (:name dired-details)
   (:name n3-mode)
   (:name graphviz-dot-mode
          :after (lambda ()
                   (setq compilation-read-command nil)
                   (define-key graphviz-dot-mode-map "\C-cc"
                     '(lambda ()
                        (interactive)
                        (compile compile-command)
                        (graphviz-dot-preview)))
   (:name sparql-mode
          :type git
          :url "https://github.com/candera/sparql-mode.git"
          :after (lambda ()
                   (autoload 'sparql-mode "sparql-mode.el"
                     "Major mode for editing SPARQL files" t)
                   (add-to-list 'auto-mode-alist '("\\.sparql$" . sparql-mode))))
   (:name org-jira
       :type git
       :url "https://github.com/baohaojun/org-jira.git"
       :after (lambda ()
                (add-hook 'org-jira-mode-hook
                          '(lambda ()
                             (setq jiralib-url "https://jira.bouvet.no")
                             (define-key org-jira-entry-mode-map "\C-cc" 'org-capture)))))
   (:name yasnippet
       :type git
       :url "https://github.com/capitaomorte/yasnippet.git")
   (:name elein)
   (:name clojure-mode
          :after (lambda ()
                   (setq paredit-mode t)))
   (:name js-comint)))

(setq my-packages
      (mapcar 'el-get-source-name el-get-sources))

(el-get 'sync my-packages)

(let ((alf-system-file (concat user-emacs-directory system-name ".el"))
      (alf-secret-file (concat user-emacs-directory "secret-settings.el")))
  (when (file-exists-p alf-system-file) (load alf-system-file))
  (when (file-exists-p alf-secret-file) (load alf-secret-file)))

(put 'ido-exit-minibuffer 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(require 'flymake)

(define-compilation-mode fabric-mode "Fabric"
  "Specialization of compilation-mode for use with fabric"
  nil)

(defvar fabric-project-path nil
  "If set, run fabric using this path")

(defvar fabric-command nil
  "If set, run fabric with this command")

(defun fabric (command)
  (interactive
   (list
    (if (or current-prefix-arg (not fabric-command))
	(read-shell-command "Enter fabric command: ")
      fabric-command)))
  (if (not (eq command fabric-command))
      (setq fabric-command command))
  (let ((dir (or
	      fabric-project-path
	      default-directory)))
    (fabric-run dir command)))

(defun fabric-run (dir command)
  (with-current-buffer (get-buffer-create "*fab*")
    (fabric-mode)
    (cd dir)
    (let ((inhibit-read-only t)
	  (proc (start-process "fabric" "*fab*" "fab" command)))
      (set-process-sentinel proc 'compilation-sentinel)
      (set-process-filter proc 'compilation-filter)
      (set-marker (process-mark proc) (point-max))
      (run-hook-with-args 'compilation-start-hook proc)
      (setq compilation-in-progress
	    (cons proc compilation-in-progress))

      (buffer-disable-undo)
      (display-buffer "*fab*")
      (erase-buffer)
      (sit-for 0)
      (end-of-buffer))))

(defun matportalen-build ()
  "Uses fabric to build the project ."
  (interactive)
  (setq fabric-project-path "~/Projects/matportalen/")
  (fabric "build"))

(defun matportalen-search-templates ()
  "Uses fabric to sync the search templates"
  (interactive)
  (setq fabric-project-path "~/Projects/matportalen/")
  (fabric "search_templates"))

(defun remove-dos-eol ()
  "Removes the disturbing '^M' showing up in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (push-mark end nil)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n"))
    (indent-region begin (mark))
    (pop-mark))
  (message "Ah, much better!"))

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
     "python -mjson.tool" (current-buffer) t)))

(defun open-index (id)
  (interactive "sEnter index-id: ")
  (let ((index-url (concat
		    "http://localhost:8080/indexer-webservice/index/"
		    id)))
    (url-retrieve index-url
		  (lambda (s id)
		    (rename-buffer (generate-new-buffer-name (concat "* index: " id)))
		    (remove-headers)
		    (bf-pretty-print-xml-region 1 (point-max))
		    (pop-to-buffer (current-buffer)))
		  (list id))))

(defun solr-search (params)
  (interactive "sEnter params: ")
  (let ((search-url (concat
                     "http://localhost:8080/solr/select?"
                     (replace-regexp-in-string "wt=javabin" "wt=xml" params))))
    (url-retrieve search-url
		  (lambda (s)
		    (rename-buffer (generate-new-buffer-name "*search-result*"))
		    (remove-headers)
		    (bf-pretty-print-xml-region 1 (point-max))
		    (pop-to-buffer (current-buffer))))))

(defun remove-headers ()
  (goto-char (point-min))
  (re-search-forward "^$" nil 'move)
  (delete-region (point-min) (1+ (point))))

(defun alf/previous-frame ()
  (interactive)
  (other-frame -1))

(defun alf/previous-window ()
  (interactive)
  (other-window -1))

(require 'compile)
(setq compile-search-file nil)
(defun find-search-file ()
  ;; Search for the pom file traversing up the directory tree.
  (setq dir (expand-file-name default-directory))
  (let ((parent (file-name-directory (directory-file-name dir))))
    (while (and (not (file-readable-p (concat dir compile-search-file)))
                (not (string= parent dir)))
      (setq dir parent
            parent (file-name-directory (directory-file-name dir))))
    (if (string= dir parent)
        (error "Search file %s is missing" compile-search-file)
      (with-current-buffer outbuf
        (setq default-directory dir)))))

(setq compilation-process-setup-function 'find-search-file)

(add-hook 'clojure-mode-hook (lambda ()
                               (define-key global-map "\C-\M-d" 'down-list)
                               (setq paredit-mode t)))
(add-hook 'java-mode-hook (lambda ()
                            (make-local-variable 'compile-search-file)
                            (setq compile-search-file "pom.xml")))

;; Add support for mvn compilation errors, taken from
;; http://jroller.com/malformed/entry/emacs_maven_2
(add-to-list 'compilation-error-regexp-alist 'mvn)
(add-to-list 'compilation-error-regexp-alist-alist
             '(mvn "\\[ERROR\\] \\(.+?\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\].*" 1 2 3))

(defun dired-open-mac ()
  (interactive)
  (let ((file-name (dired-get-file-for-visit)))
    (if (file-exists-p file-name)
        (call-process "/usr/bin/open" nil 0 nil file-name))))

(add-hook 'dired-load-hook (lambda ()
                             (load "dired-x")
                             (define-key dired-mode-map "o" 'dired-open-mac)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(if (eq system-type 'darwin)
    (custom-set-variables
     '(ns-command-modifier 'meta)
     '(ns-right-command-modifier 'meta)
     '(ns-option-modifier nil)
     '(ns-right-option-modifier nil)))

;; Setup expansion
(define-key global-map "\M-/" 'dabbrev-expand)
(define-key read-expression-map [(tab)] 'hippie-expand)
(define-key read-expression-map [(shift tab)] 'unexpand)

;; quick access to stuff I use a lot
(define-key global-map [(f9)] 'recompile)
(define-key global-map [(f10)] 'matportalen-build)
(define-key global-map [(f11)] 'matportalen-search-templates)

;; since I don't have a super-key use Ctrl-/ for comment/uncomment
(define-key global-map [(ctrl /)] 'comment-or-uncomment-region-or-line)

;; upgrade a few builtins
(define-key global-map "\C-x\C-b" 'ibuffer)
(define-key global-map "\C-x\C-d" 'ido-dired)

(add-hook 'ibuffer-mode-hooks '(lambda ()
				 (define-key ibuffer-mode-map "\C-x\C-f" 'ido-find-file)
				 (define-key ibuffer-mode-map [(shift return)] 'ibuffer-visit-buffer-other-window)))

;; Full screen is soooo lovely
(define-key global-map [(meta return)] 'ns-toggle-fullscreen)

;; Make it easier to switch between frames
(define-key global-map "\M-`" 'other-frame)
(define-key global-map "\M-~" 'alf/previous-frame)

;; Make it easier to switch back to previous window
(define-key global-map "\C-xO" 'alf/previous-window)

;; Map the norwegian characters for convenience
(define-key global-map [(super a)]  (kbd "å"))
(define-key global-map [(super A)]  (kbd "Å"))
(define-key global-map [(super o)]  (kbd "ø"))
(define-key global-map [(super O)]  (kbd "Ø"))
(define-key global-map [(super \')] (kbd "æ"))
(define-key global-map [(super \")] (kbd "Æ"))

;; window movement commands inspired by emacs
(define-key global-map "\C-z" nil)
(define-key global-map "\C-zh" 'windmove-left)
(define-key global-map "\C-zl" 'windmove-right)
(define-key global-map "\C-zk" 'windmove-up)
(define-key global-map "\C-zj" 'windmove-down)

(setq auto-mode-alist
      (cons '("\\.zcml\\'" . nxml-mode)
            auto-mode-alist))

(setq auto-mode-alist
      (cons '("\\.pt\\'" . nxml-mode)
            auto-mode-alist))

(add-hook 'python-mode-hook
	  (lambda()
	    (set (make-local-variable 'compile-command) (concat "python " (buffer-name)))))

(defadvice python-calculate-indentation (around outdent-closing-brackets)
  "Handle lines beginning with a closing bracket and indent them so that
they line up with the line containing the corresponding opening bracket."
  (save-excursion
    (beginning-of-line)
    (let ((syntax (syntax-ppss)))
      (if (and (not (eq 'string (syntax-ppss-context syntax)))
               (python-continuation-line-p)
               (cadr syntax)
               (skip-syntax-forward "-")
               (looking-at "\\s)"))
          (progn
            (forward-char 1)
            (ignore-errors (backward-sexp))
            (setq ad-return-value (current-indentation)))
        ad-do-it))))

(ad-activate 'python-calculate-indentation)

(when (load "flymake" t)
  (require 'tramp-cmds)
  (setq flymake-gui-warnings-enabled nil)

  (defun flymake-check-init ()
    ;; Make sure it's not a remote buffer or flymake would not work
    (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "check.py" (list local-file)))))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-check-init)))

(require 'org-install)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)
(define-key global-map "\C-cc" 'org-capture)

(setq dropbox-dir (expand-file-name "~/Dropbox"))
(setq org-directory (file-name-as-directory
		     (expand-file-name "Org" dropbox-dir)))

(let ((default-directory org-directory))
  (setq org-agenda-files
	(mapcar 'expand-file-name
		(list "inbox.org"
		      "projects")))


  (setq org-capture-templates
	`(("t" "Inbox" entry
	   (file ,(expand-file-name "inbox.org"))
	   "* TODO %?\n %i\n")
	  ("j" "Journal" entry
	   (file+datetree ,(expand-file-name "journal.org"))
	   "* %?\nEntered on %U\n  %i")
	  ("b" "Blog idea" entry
	   (file+headline ,(expand-file-name "blog-ideas.org") "Blog ideas")
	   "** %?\n%u\n"))))

(setq org-timer-default-timer 25)

(add-hook 'org-mode-hook
	  '(lambda()
	     (setq fill-column 78)))


;; From http://doc.norang.ca/org-mode.html#Clocking
;; Resume clocking tasks when emacs is restarted
(org-clock-persistence-insinuate)
;; Yes it's long... but more is better ;)
(setq org-clock-history-length 28)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change task state to NEXT when clocking in
(setq org-clock-in-switch-to-state (quote bh/clock-in-to-started))
;; Separate drawers for clocking and logs
(setq org-drawers '("PROPERTIES" "LOGBOOK" "CLOCK"))
(setq org-startup-folded "content")
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s!/!)" "WAITING(w@/!)" "DELEGATED(e@/!)" "|" "DONE(d@/!)" "DEFERRED" "CANCELLED(c@)")))

;; Save clock data in the CLOCK drawer and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer "CLOCK")
(setq org-log-into-drawer "LOGBOOK")
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist (quote history))
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq bh/keep-clock-running nil)

(defun bh/clock-in ()
  (interactive)
  (setq bh/keep-clock-running t)
  (org-agenda nil "c"))

(defun bh/clock-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out)))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running (not org-clock-clocking-in) (marker-buffer org-clock-default-task))
    (bh/clock-in-default-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)
;; $Revision: 1.1.1.1 $

;; Copyright (C) 2000 by Ingo Koch

;; Author: ingo Koch <ingo.koch@ikoch.de>
;; The Idea and a lot of the code is stolen from the
;; .emacs file of  Jake Donham <jake@bitmechanic.com>
;; available at http://www.jaked.org/emacs.html
;; who did this for the mocha java decompiler
;; Maintainer: Ingo Koch <ingo.koch@ikoch.de>
;; Keywords: java, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Description:

;; This package is an add-on to the Java Development Environment
;; (JDE) for Emacs. It automatically decompiles a class file and
;; offers you a buffer to view or edit it.
;; javadecomp (currently) relies on the jad java decompiler to
;; do the actual work, but it should be possible to extend it to
;; whatever you like (sugestions are welcome).
;; jad is available at the Jad home page:
;; http://www.geocities.com/SiliconValley/Bridge/8617/jad.html
;; by Pavel Kouznetsov (kpdus@yahoo.com).
;; It supports a wide range of OS like:
;; - Windows 95/NT on Intel platform
;; - Linux on Intel platform
;; - Solaris 7.0 on Intel platform
;; - Rhapsody 5.3 on PowerPC platform
;; - AIX 4.2 on IBM RS/6000 platform
;; - OS/2
;; - Solaris 2.5 on SUN Sparc platform
;; - FreeBSD 2.2.x

;;; Installation:

;; Put the following in your .emacs file:
;;   (require 'javadecomp)
;;
;;; Usage:
;; Open a class file and feel happy.

;;; Support:

;; Any comments, suggestions, bug reports or upgrade requests are welcome.
;; Please send them to Ingo Koch at ingo.koch@ikoch.de.
;;

;;; Code:

(defvar jdc-command  "/usr/local/bin/jad"
  "The name of the decompiler if it's on your path, otherwise
a full qualified path to it.")

(defvar jdc-parameter  " -space -t2 "
  "Extra parameter which should be added to the call of the decompiler.")

(defvar jdc-extension  "jad"
  "The extension which is used for the generated java files.")

(defun jdc-find-file ()
  "Find a classfile and decompile it, opening the decompiled file instead."
  (interactive)
  (let ((jdc-classfile (read-file-name ".class file: ")))
    (find-file jdc-classfile)
    (jdc-buffer)
    (java-mode)))

(defun jdc-buffer ()
  "Construct the command for decompiling a class file, call the resulting
command and load the decompiled file."
  (let*
      (
       (jdc-classfile (file-name-nondirectory (buffer-file-name)))
       (jdc-javafile (concat (substring jdc-classfile 0 -5) jdc-extension))
       (command (concat jdc-command jdc-parameter jdc-classfile)))

    (shell-command command)
    (find-alternate-file jdc-javafile)))

;; a hook to be able to automatically decompile-find-file .class files
(add-hook
 'find-file-hooks
 (lambda ()
   (let ((file (buffer-file-name)))
     (cond ((string= (substring file -6) ".class")
	    (progn (jdc-buffer) (java-mode)))))))

(provide 'javadecomp)

(defun maximize-frame ()
  (interactive)
  (set-frame-position (selected-frame) 0 20)
  (set-frame-size (selected-frame) 270 76))

(defun my-js-mode-hook ()
  (imenu-add-menubar-index)
  ;; Activate the folding mode
  (hs-minor-mode t))

(add-hook 'js-mode-hook 'my-js-mode-hook)

(setq inferior-js-mode-hook
      (lambda ()
        ;; We like nice colors
        (ansi-color-for-comint-mode-on)
       ;; Deal with some prompt nonsense
        (add-to-list 'comint-preoutput-filter-functions
                     (lambda (output)
                       (replace-regexp-in-string ".*1G\.\.\..*5G" "..."
                     (replace-regexp-in-string ".*1G.*3G" "> " output))))))

(fset 'yes-or-no-p 'y-or-n-p)

;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)

;; Enable Semantic
(semantic-mode 1)
  (defun create-tags (dir-name)
     "Create tags file."
     (interactive "DDirectory: ")
     (eshell-command
      (format "find %s -type f -name \"*.java\" | etags --append -" dir-name)))
