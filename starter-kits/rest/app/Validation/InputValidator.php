<?php

declare(strict_types=1);

namespace App\Validation;

use Phalcon\Filter\FilterFactory;
use Phalcon\Validation;
use Phalcon\Validation\Validator\Email;

final class InputValidator
{
    private FilterFactory $filterFactory;

    public function __construct(?FilterFactory $filterFactory = null)
    {
        $this->filterFactory = $filterFactory ?? new FilterFactory();
    }

    public function sanitizeEmail(mixed $value): ?string
    {
        if (!is_string($value)) {
            return null;
        }

        $filter = $this->filterFactory->newInstance();
        $sanitized = (string) $filter->sanitize($value, 'email');
        if ($sanitized === '') {
            return null;
        }

        $validation = new Validation();
        $validation->add('email', new Email());
        $messages = $validation->validate(['email' => $sanitized]);

        return count($messages) === 0 ? $sanitized : null;
    }
}
