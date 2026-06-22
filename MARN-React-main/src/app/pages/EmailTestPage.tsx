import React, { useState } from 'react';

const emailTemplates = [
  {
    name: 'Send Confirm Email',
    html: `<!DOCTYPE html>
<html>
  <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f2f4f6; margin: 0; padding: 40px 20px;">
    <div style="max-width: 600px; margin: auto; background: #ffffff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 24px rgba(0,0,0,0.05); text-align: center;">
      <h2 style="color: #1a1a1a; font-size: 24px; margin-bottom: 16px; margin-top: 0;">Welcome to MARN, {firstName}!</h2>
      <p style="font-size: 16px; color: #4a5565; line-height: 1.6; margin-bottom: 32px;">Thank you for registering. Please confirm your email by clicking the button below to get started.</p>
      <a href="{confirmationLink}" style="display: inline-block; background: #3a6ea5; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px; transition: background 0.2s;">Confirm Your Email</a>
      <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 40px 0 20px 0;" />
      <p style="font-size: 13px; color: #99a1af; margin: 0;">&copy; {DateTime.UtcNow.Year} MARN. All rights reserved.</p>
    </div>
  </body>
</html>`
  },
  {
    name: 'Created Email',
    html: `<!DOCTYPE html>
<html>
  <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f2f4f6; margin: 0; padding: 40px 20px;">
    <div style="max-width: 600px; margin: auto; background: #ffffff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 24px rgba(0,0,0,0.05); text-align: center;">
      <div style="width: 64px; height: 64px; border-radius: 50%; background-color: #e8f5e9; margin: 0 auto 24px auto; line-height: 64px; text-align: center;">
        <span style="color: #2e7d32; font-size: 32px; font-weight: bold;">&#10003;</span>
      </div>
      <h2 style="color: #1a1a1a; font-size: 24px; margin-bottom: 16px; margin-top: 0;">Account Created, {firstName}!</h2>
      <p style="font-size: 16px; color: #4a5565; line-height: 1.6; margin-bottom: 32px;">Your account has been successfully created and your email is confirmed. You are ready to go!</p>
      <a href="{loginLink}" style="display: inline-block; background: #3a6ea5; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">Login to Your Account</a>
      <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 40px 0 20px 0;" />
      <p style="font-size: 13px; color: #99a1af; margin: 0;">&copy; {DateTime.UtcNow.Year} MARN. All rights reserved.</p>
    </div>
  </body>
</html>`
  },
  {
    name: 'Resend Confirm Email',
    html: `<!DOCTYPE html>
<html>
  <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f2f4f6; margin: 0; padding: 40px 20px;">
    <div style="max-width: 600px; margin: auto; background: #ffffff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 24px rgba(0,0,0,0.05); text-align: center;">
      <h2 style="color: #1a1a1a; font-size: 24px; margin-bottom: 16px; margin-top: 0;">Hello, {firstName}!</h2>
      <p style="font-size: 16px; color: #4a5565; line-height: 1.6; margin-bottom: 32px;">You requested a new email confirmation link. Please confirm your email by clicking the button below.</p>
      <a href="{confirmationLink}" style="display: inline-block; background: #3a6ea5; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">Confirm Your Email</a>
      <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 40px 0 20px 0;" />
      <p style="font-size: 13px; color: #99a1af; margin: 0;">&copy; {DateTime.UtcNow.Year} MARN. All rights reserved.</p>
    </div>
  </body>
</html>`
  },
  {
    name: 'Reset Password Email',
    html: `<!DOCTYPE html>
<html>
  <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f2f4f6; margin: 0; padding: 40px 20px;">
    <div style="max-width: 600px; margin: auto; background: #ffffff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 24px rgba(0,0,0,0.05); text-align: center;">
      <h2 style="color: #1a1a1a; font-size: 24px; margin-bottom: 16px; margin-top: 0;">Reset Password</h2>
      <p style="font-size: 16px; color: #4a5565; line-height: 1.6; margin-bottom: 32px;">Hello {firstName}, you requested to reset your password. Click the button below to set a new password.</p>
      <a href="{resetLink}" style="display: inline-block; background: #3a6ea5; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">Reset Password</a>
      <p style="font-size: 14px; color: #6a7282; margin-top: 24px;">This link will expire in 1 hour.</p>
      <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 40px 0 20px 0;" />
      <p style="font-size: 13px; color: #99a1af; margin: 0;">&copy; {DateTime.UtcNow.Year} MARN. All rights reserved.</p>
    </div>
  </body>
</html>`
  },
  {
    name: 'Send 2FA Email',
    html: `<!DOCTYPE html>
<html>
  <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f2f4f6; margin: 0; padding: 40px 20px;">
    <div style="max-width: 600px; margin: auto; background: #ffffff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 24px rgba(0,0,0,0.05); text-align: center;">
      <h2 style="color: #1a1a1a; font-size: 24px; margin-bottom: 16px; margin-top: 0;">Two-Factor Authentication</h2>
      <p style="font-size: 16px; color: #4a5565; line-height: 1.6; margin-bottom: 32px;">Use the verification code below to complete your sign-in.</p>
      <div style="display: inline-block; font-size: 32px; font-weight: 700; letter-spacing: 8px; color: #3a6ea5; background: #f8f9fb; padding: 20px 32px; border-radius: 12px; border: 1px solid rgba(58, 110, 165, 0.2); margin-bottom: 32px;">
        {code}
      </div>
      <p style="font-size: 14px; color: #6a7282; line-height: 1.5; margin-bottom: 0;">This code will expire in 5 minutes.<br/>If you did not request this code, please ignore this email.</p>
      <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 40px 0 20px 0;" />
      <p style="font-size: 13px; color: #99a1af; margin: 0;">&copy; {DateTime.UtcNow.Year} MARN. All rights reserved.</p>
    </div>
  </body>
</html>`
  },
  {
    name: 'Contact Request Email',
    html: `<!DOCTYPE html>
<html>
  <body style="font-family: 'Inter', Arial, sans-serif; background-color: #f2f4f6; margin: 0; padding: 40px 20px;">
    <div style="max-width: 600px; margin: auto; background: #ffffff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 24px rgba(0,0,0,0.05);">
      <h2 style="color: #1a1a1a; font-size: 24px; margin-bottom: 24px; margin-top: 0; text-align: center;">New Contact Request</h2>
      
      <div style="background: #f8f9fb; padding: 24px; border-radius: 12px; border: 1px solid rgba(58, 110, 165, 0.1); margin-bottom: 24px;">
        <table width="100%" cellpadding="0" cellspacing="0" style="font-size: 15px; color: #4a5565; line-height: 1.6;">
          <tr>
            <td style="padding: 8px 0; font-weight: 600; color: #1a1a1a; width: 140px;">User ID:</td>
            <td style="padding: 8px 0;">{userId}</td>
          </tr>
          <tr>
            <td style="padding: 8px 0; font-weight: 600; color: #1a1a1a;">Full Name:</td>
            <td style="padding: 8px 0;">{fullName}</td>
          </tr>
          <tr>
            <td style="padding: 8px 0; font-weight: 600; color: #1a1a1a;">Contact Email:</td>
            <td style="padding: 8px 0;">{contactEmail}</td>
          </tr>
          <tr>
            <td style="padding: 8px 0; font-weight: 600; color: #1a1a1a;">Phone Number:</td>
            <td style="padding: 8px 0;">{phoneNumber}</td>
          </tr>
          <tr>
            <td style="padding: 8px 0; font-weight: 600; color: #1a1a1a;">Subject:</td>
            <td style="padding: 8px 0;">{subject}</td>
          </tr>
        </table>
      </div>

      <div style="margin-bottom: 16px;">
        <strong style="color: #1a1a1a; font-size: 16px;">Message:</strong>
      </div>
      <div style="background: #ffffff; padding: 20px; border-radius: 12px; border: 1px solid #e5e7eb; color: #4a5565; font-size: 15px; line-height: 1.6; white-space: pre-wrap;">{message}</div>

      <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 40px 0 20px 0;" />
      <p style="font-size: 13px; color: #99a1af; margin: 0; text-align: center;">&copy; {DateTime.UtcNow.Year} MARN. All rights reserved.</p>
    </div>
  </body>
</html>`
  }
];

// Helper to replace placeholders with dummy data for preview
const renderHtmlWithData = (html: string) => {
  return html
    .replace(/{firstName}/g, 'John')
    .replace(/{confirmationLink}/g, '#')
    .replace(/{loginLink}/g, '#')
    .replace(/{resetLink}/g, '#')
    .replace(/{code}/g, '824915')
    .replace(/{DateTime\.UtcNow\.Year}/g, new Date().getFullYear().toString())
    .replace(/{userId}/g, '11111111-1111-1111-1111-111111111111')
    .replace(/{fullName}/g, 'John Doe')
    .replace(/{contactEmail}/g, 'user@example.com')
    .replace(/{phoneNumber}/g, '01096154355')
    .replace(/{subject}/g, 'Inquiry about MARN services')
    .replace(/{message}/g, 'Hello, I would like to know more about how your property management system works and what are the pricing plans available.');
};

export default function EmailTestPage() {
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [viewMode, setViewMode] = useState<'preview' | 'code'>('preview');

  const selectedTemplate = emailTemplates[selectedIndex];

  return (
    <div className="flex flex-col h-screen bg-background">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between p-6 bg-card border-b border-border gap-4">
        <div>
          <h1 className="text-2xl font-bold text-foreground">Email Template Viewer</h1>
          <p className="text-muted-foreground text-sm mt-1">Select a template to preview or copy the HTML code.</p>
        </div>

        <div className="flex items-center gap-4">
          <select
            className="p-2 bg-background border border-input rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-ring"
            value={selectedIndex}
            onChange={(e) => setSelectedIndex(Number(e.target.value))}
          >
            {emailTemplates.map((t, i) => (
              <option key={i} value={i}>{t.name}</option>
            ))}
          </select>

          <div className="flex bg-muted p-1 rounded-lg">
            <button
              onClick={() => setViewMode('preview')}
              className={`px-4 py-1.5 text-sm font-medium rounded-md transition-colors ${viewMode === 'preview' ? 'bg-card text-foreground shadow-sm' : 'text-muted-foreground hover:text-foreground'}`}
            >
              Preview
            </button>
            <button
              onClick={() => setViewMode('code')}
              className={`px-4 py-1.5 text-sm font-medium rounded-md transition-colors ${viewMode === 'code' ? 'bg-card text-foreground shadow-sm' : 'text-muted-foreground hover:text-foreground'}`}
            >
              Code
            </button>
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-auto bg-[#f8f9fb] p-6 flex justify-center items-start">
        {viewMode === 'preview' ? (
          <div
            className="w-full max-w-[800px] bg-white rounded-xl shadow-sm border border-border overflow-hidden"
            dangerouslySetInnerHTML={{ __html: renderHtmlWithData(selectedTemplate.html) }}
          />
        ) : (
          <div className="w-full max-w-[800px] relative">
            <button
              className="absolute top-4 right-4 bg-primary text-primary-foreground px-4 py-2 rounded-md text-sm font-medium hover:bg-primary/90 transition-colors"
              onClick={() => {
                navigator.clipboard.writeText(selectedTemplate.html);
                alert('Copied to clipboard!');
              }}
            >
              Copy Code
            </button>
            <pre className="bg-[#1e1e1e] text-[#d4d4d4] p-6 rounded-xl overflow-auto text-sm shadow-sm border border-border h-full">
              <code>{selectedTemplate.html}</code>
            </pre>
          </div>
        )}
      </div>
    </div>
  );
}
