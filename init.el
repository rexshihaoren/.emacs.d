;; Basic Setup
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
(with-current-buffer
(url-retrieve-synchronously
"https://raw.github.com/dimitri/el-get/master/el-get-install.el")
(let (el-get-master-branch
;; do not build recipes from emacswiki
el-get-install-skip-emacswiki-recipes)
(goto-char (point-max))
(eval-print-last-sexp)))
;; build melpa packages for el-get
(el-get-install 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
("melpa-stable" . "https://stable.melpa.org/packages/")
("melpa" . "http://melpa.org/packages/")))
(el-get-elpa-build-local-recipes))

;; Set my packages
(setq
 rex-packages
 (append
  '(el-get
    ensime
    hive
    auto-complete
    sql-indent
    evil
    evil-escape
    ;;evil-tutor
    elpy
    pig-mode
    neotree
    helm
    powerline
    helm-projectile
    projectile
    magit
    smartparens
    ;; ess
    ein
    which-key
    fill-column-indicator
    ace-window
    material-theme
    rainbow-delimiters
    exec-path-from-shell)
    ))
(el-get-bundle ensime
  :type github
  :pkgname "ensime/ensime-emacs"
  :branch "1.0")
;; add recipes
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
;; install new packages and init already installed packages
(el-get 'sync rex-packages)
;; execute from shell
(when (memq window-system '(mac ns))
(exec-path-from-shell-initialize))
;; Material theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/material-theme")

;; Visual Setting
(load-theme 'material t)
(powerline-default-theme)
(add-hook 'text-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'pig-mode-hook #'rainbow-delimiters-mode)
(setq inhibit-splash-screen t)
(set-face-attribute 'default nil :height 140)
(blink-cursor-mode -1)
;; (line-number-mode t)
(unless (string-match "apple" system-configuration)
;; on mac, there's always a menu bar drown, don't have it empty
(menu-bar-mode -1))
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; tabs setting
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
;; ;; tabs to 4 spaces for python
;; (add-hook 'python-mode-hook                       
;;       (lambda ()                                  
;;         (setq indent-tabs-mode t)                 
;;         (setq tab-width 4)                        
;;         (setq python-indent 4)))                  
;; ;; tabs to 8 spaces for shell-script              
;; (add-hook 'sh-mode-hook                           
;;       (lambda ()                                  
;;         (setq indent-tabs-mode t)                 
;;         (setq tab-width 4)                        
;;         (setq indent-line-function 'insert-tab))) 
;; full screen
(defun fullscreen ()
(interactive)
(set-frame-parameter nil 'fullscreen
(if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key (kbd "M-m") 'fullscreen)
;; auto fill
(global-visual-line-mode 1)

;; Package Setting
;; neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
;; evil
(evil-mode 1)
(evil-escape-mode 1)
(setq-default evil-escape-key-sequence "jk")
;; python
(elpy-enable)
;; ace-window
(global-set-key (kbd "M-p") 'ace-window)
(setq aw-dispatch-always t)
;; which key
(which-key-mode)
;; fill column indicator
;; (setq fci-rule-width 1)
;; (setq-default fci-rule-column 72)
;; (add-hook 'after-change-major-mode-hook 'fci-mode)
;; .hql use sql-mode
(setq auto-mode-alist (cons '("\\.hql$" . sql-mode) auto-mode-alist))
;; helm
(helm-mode 1)
(setq helm-display-header-line nil
helm-split-window-in-side-p t
helm-move-to-line-cycle-in-source t
helm-scroll-amount 8
helm-ff-file-name-history-use-recentf t)
(setq helm-autoresize-max-height 30)
(setq helm-autoresize-min-height 30)
(setq helm-split-window-in-side-p t)
;; (global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
;; auto-complete
(ac-config-default)
;; projectile
(projectile-global-mode)
(setq projectile-enable-caching t)
(setq projectile-switch-project-action 'projectile-dired)
(require 'helm-projectile)
(helm-projectile-on)
;; smart paren
(show-smartparens-mode +1)
;; TRAMP
(setq tramp-default-method "scp")
;; Some more key binding
;; open init file
(global-set-key (kbd "C-c p n")
(lambda () (interactive) (find-file user-init-file)))
(global-set-key (kbd "C-x g") 'magit-status)

;; pig-mode config
(setq pig-executable "/usr/local/bin/pig")
(setq pig-executable-options '("-x" "local"))
(setq pig-executable-prompt-regexp "^grunt> ")
(setq pig-indent-level 4)
(setq pig-version "0.15.0")
;; Scala
(require 'ensime)

;;; Customization
(eval-after-load "sql"
  '(load-library "sql-indent"))
