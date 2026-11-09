# typed: true
# frozen_string_literal: true

# Entry point when running tests (-r test_loader): rspock, then
# ASTTransform.install — the rspock test dialect is rewritten at load time,
# so the hook must be in place before any test file loads. test_helper is
# required by each test file and provides Minitest.
require "rspock"

ASTTransform.install
