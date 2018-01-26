;;; meson-build.el --- Meson build support for Emacs. -*- lexical-binding: t -*-

;; Copyright (C) 2018 Veeti Kraft

;; Author: Veeti Kraft <veeti.kraft@gmail.com>
;; Version: 0.1.0
;; Keywords: tools meson
;; Package-Requires: ((emacs "25"))

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; meson-build is a GNU Emacs package for building projects with Meson.


;;; Code:

(require 'compile)

(defvar meson-build-root-file "meson.build"
  "Name of the file to use to identify a project's root directory.")

(defvar meson-build-build-directory-name "dist"
  "Name of the Meson build directory to use.")

;;;###autoload
(defun meson-build-start-build ()
  "Start a Meson build for the current project."
  (interactive)
  (let ((build-directory (meson-build--get-build-directory)))
    (if build-directory
        (progn
          (save-some-buffers)
          (compilation-start
           (concat
            "cd " (shell-quote-argument build-directory)
            "&& ninja"))
          t)
      (message "meson-build: Couldn't find the project root. Cannot build.")
      nil)))


(defun meson-build--above-directory (dir)
  "Return path to the directory above DIR or nil if DIR is \"/\".

DIR must be an absolute path."
  (if (not (equal dir "/"))
      (file-name-directory (directory-file-name dir))
    nil))

(defun meson-build--find-project-root (dir)
  "Find the current project's root directory.

DIR indicates the directory from which to start the search."
  (let* ((absdir (expand-file-name (file-name-as-directory dir)))
         (files (directory-files absdir)))
    (if (member meson-build-root-file files)
        absdir
      (if (equal absdir (expand-file-name "~/"))
          ;; Don't go above the home directory.
          nil
        ;; Try one level closer to root.
        (meson-build--find-project-root
         (meson-build--above-directory absdir))))))

(defun meson-build--get-build-directory ()
  "Return the absolute path to this project's build directory."
  (let ((project-root (meson-build--find-project-root "./")))
    (when project-root
      (concat project-root (file-name-as-directory meson-build-build-directory-name)))))


(provide 'meson-build)
;;; meson-build.el ends here
