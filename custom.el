(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(autopair-global-mode t)
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(column-number-mode t)
 '(compilation-scroll-output (quote first-error))
 '(custom-safe-themes (quote ("381c92f4ee13b5ffe4e269a8b5cbf763faf1c9ea" "517aecb1202bfa31fd3c44473d72483c5166124d" default)))
 '(dabbrev-case-fold-search nil)
 '(dabbrev-search-these-buffers-only nil)
 '(desktop-save-mode nil)
 '(diff-switches "-u")
 '(display-buffer-reuse-frames t)
 '(enable-recursive-minibuffers t)
 '(erc-hide-list (quote ("JOIN" "NICK" "PART" "QUIT")))
 '(erc-nick "alfborge")
 '(evil-emacs-state-modes (quote (eshell-mode bbdb-mode bookmark-bmenu-mode bookmark-edit-annotation-mode browse-kill-ring-mode bzr-annotate-mode calc-mode cfw:calendar-mode completion-list-mode Custom-mode debugger-mode delicious-search-mode desktop-menu-blist-mode desktop-menu-mode doc-view-mode dvc-bookmarks-mode dvc-diff-mode dvc-info-buffer-mode dvc-log-buffer-mode dvc-revlist-mode dvc-revlog-mode dvc-status-mode dvc-tips-mode ediff-mode efs-mode Electric-buffer-menu-mode emms-browser-mode emms-mark-mode emms-metaplaylist-mode emms-playlist-mode ert-results-mode etags-select-mode fj-mode gc-issues-mode gdb-breakpoints-mode gdb-disassembly-mode gdb-frames-mode gdb-locals-mode gdb-memory-mode gdb-registers-mode gdb-threads-mode gist-list-mode gnus-article-mode gnus-browse-mode gnus-group-mode gnus-server-mode gnus-summary-mode google-maps-static-mode ibuffer-mode jde-javadoc-checker-report-mode magit-commit-mode magit-diff-mode magit-key-mode magit-log-mode magit-mode magit-reflog-mode magit-show-branches-mode magit-stash-mode magit-status-mode magit-wazzup-mode mh-folder-mode monky-mode notmuch-hello-mode notmuch-search-mode notmuch-show-mode occur-mode org-agenda-mode package-menu-mode proced-mode rcirc-mode rebase-mode recentf-dialog-mode reftex-toc-mode sldb-mode slime-inspector-mode slime-thread-control-mode slime-xref-mode sr-buttons-mode sr-mode sr-tree-mode sr-virtual-mode tar-mode tetris-mode tla-annotate-mode tla-archive-list-mode tla-bconfig-mode tla-bookmarks-mode tla-branch-list-mode tla-browse-mode tla-category-list-mode tla-changelog-mode tla-follow-symlinks-mode tla-inventory-file-mode tla-inventory-mode tla-lint-mode tla-logs-mode tla-revision-list-mode tla-revlog-mode tla-tree-lint-mode tla-version-list-mode twittering-mode urlview-mode vc-annotate-mode vc-dir-mode vc-git-log-view-mode vm-mode vm-summary-mode w3m-mode wab-compilation-mode xgit-annotate-mode xgit-changelog-mode xgit-diff-mode xgit-revlog-mode xhg-annotate-mode xhg-log-mode xhg-mode xhg-mq-mode xhg-mq-sub-mode xhg-status-extra-mode info-mode dired-mode)))
 '(evil-insert-state-modes (quote (comint-mode erc-mode geiser-repl-mode gud-mode inferior-apl-mode inferior-caml-mode inferior-emacs-lisp-mode inferior-j-mode inferior-python-mode inferior-scheme-mode inferior-sml-mode internal-ange-ftp-mode prolog-inferior-mode reb-mode shell-mode slime-repl-mode term-mode wdired-mode)))
 '(exec-path (quote ("/Users/alf.lervag/local/bin" "/usr/local/Cellar/python/2.7.1/bin" "/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin")))
 '(find-grep-options "-q  --exclude=\"*.svn-base\" --exclude=\"*~\" --exclude=\"*.pyc\"")
 '(hl-needed-mode t)
 '(hl-needed-on-config-change nil)
 '(ido-create-new-buffer (quote never))
 '(ido-enable-flex-matching t)
 '(ido-enable-last-directory-history nil)
 '(ido-enable-regexp nil)
 '(ido-max-directory-size 300000)
 '(ido-max-file-prompt-width 0.1)
 '(ido-mode (quote both) nil (ido))
 '(ido-use-filename-at-point (quote guess))
 '(ido-use-url-at-point t)
 '(ido-use-virtual-buffers t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(jabber-account-list (quote (("alfborge@gmail.com" (:network-server . "talk.google.com") (:connection-type . ssl)))))
 '(js-indent-level 4)
 '(line-number-mode t)
 '(mark-even-if-inactive t)
 '(menu-bar-mode nil)
 '(mumamo-chunk-coloring 5)
 '(ns-alternate-modifier nil)
 '(ns-command-modifier (quote meta))
 '(ns-right-alternate-modifier nil)
 '(ns-right-command-modifier (quote meta))
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-deadline-warning-days 14)
 '(savehist-mode t)
 '(scroll-bar-mode nil)
 '(send-mail-function (quote smtpmail-send-it))
 '(server-mode t)
 '(set-mark-command-repeat-pop t)
 '(smtpmail-default-smtp-server "localhost" t)
 '(smtpmail-local-domain "bouvet.no" t)
 '(smtpmail-sendto-domain "bouvet.no" t)
 '(smtpmail-smtp-service 1025 t)
 '(smtpmail-smtp-user "alf.lervag@bouvet.no" t)
 '(tool-bar-mode nil)
 '(transient-mark-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(vc-bzr-log-switches "--include-merges")
 '(yas/prompt-functions (quote (yas/ido-prompt yas/completing-prompt yas/dropdown-prompt yas/x-prompt yas/no-prompt))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((((background dark)) (:foreground "#7474FFFF7474")) (t (:foreground "DarkGreen"))))
 '(diff-changed ((((background dark)) (:foreground "Yellow")) (t (:foreground "MediumBlue"))))
 '(diff-context ((((background dark)) (:foreground "White")) (t (:foreground "Black"))))
 '(diff-file-header ((((background dark)) (:foreground "Cyan" :background "Black")) (t (:foreground "Red" :background "White"))))
 '(diff-header ((((background dark)) (:foreground "Cyan")) (t (:foreground "Red"))))
 '(diff-hunk-header ((((background dark)) (:foreground "Black" :background "#05057F7F8D8D")) (t (:foreground "White" :background "Salmon"))))
 '(diff-index ((((background dark)) (:foreground "Magenta")) (t (:foreground "Green"))))
 '(diff-indicator-added ((((background dark)) (:foreground "#111117175555" :background "#7474FFFF7474")) (t nil)))
 '(diff-indicator-removed ((((background dark)) (:foreground "#111117175555" :background "#FFFF9B9BFFFF")) (t nil)))
 '(diff-nonexistent ((((background dark)) (:foreground "#FFFFFFFF7474")) (t (:foreground "DarkBlue"))))
 '(diff-refine-change ((t nil)))
 '(diff-removed ((((background dark)) (:foreground "#FFFF9B9BFFFF")) (t (:foreground "DarkMagenta"))))
 '(org-hide ((((background light)) (:foreground "white")) (((background dark)) (:foreground "grey20")))))
