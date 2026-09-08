package com.mouse.app

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.graphics.Color
import android.graphics.Path
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.os.Build
import android.content.Intent
import android.content.IntentFilter

class MouseAccessibilityService : AccessibilityService() {

    private var windowManager: WindowManager? = null
    private var cursorView: View? = null

    private var downX = 0f
    private var downY = 0f
    private var moved = false

    override fun onServiceConnected() {
        super.onServiceConnected()
        showCursor()
    }

    private fun showCursor() {
        if (cursorView != null) return

        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        val cursor = View(this)

        val drawable = GradientDrawable()
        drawable.shape = GradientDrawable.OVAL
        drawable.setColor(Color.WHITE)
        drawable.setStroke(4, Color.BLACK)

        cursor.background = drawable

        val size = 55

        val params = WindowManager.LayoutParams(
            size,
            size,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            android.graphics.PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.TOP or Gravity.START
        params.x = 300
        params.y = 500

        cursor.setOnTouchListener { _, event ->

            when (event.action) {

                MotionEvent.ACTION_DOWN -> {
                    downX = event.rawX
                    downY = event.rawY
                    moved = false
                    true
                }

                MotionEvent.ACTION_MOVE -> {
                    val dx = event.rawX - downX
                    val dy = event.rawY - downY

                    if (kotlin.math.abs(dx) > 5 || kotlin.math.abs(dy) > 5) {
                        moved = true
                    }

                    params.x = (params.x + dx).toInt()
                    params.y = (params.y + dy).toInt()

                    downX = event.rawX
                    downY = event.rawY

                    windowManager?.updateViewLayout(cursor, params)
                    true
                }

                MotionEvent.ACTION_UP -> {

                    if (!moved) {
                        clickAt(params.x + size / 2, params.y + size / 2)
                    }

                    true
                }

                else -> false
            }
        }

        windowManager?.addView(cursor, params)

        cursorView = cursor
    }

    private fun clickAt(x: Int, y: Int) {

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) return

        val path = Path()
        path.moveTo(x.toFloat(), y.toFloat())

        val stroke = GestureDescription.StrokeDescription(
            path,
            0,
            100
        )

        val gesture = GestureDescription.Builder()
            .addStroke(stroke)
            .build()

        dispatchGesture(
            gesture,
            null,
            null
        )
    }

    private fun hideCursor() {
        cursorView?.let {
            try {
                windowManager?.removeView(it)
            } catch (_: Exception) {
            }
        }

        cursorView = null
    }

    override fun onDestroy() {
        hideCursor()
        super.onDestroy()
    }

    override fun onInterrupt() {
    }

    override fun onAccessibilityEvent(event: android.view.accessibility.AccessibilityEvent?) {
    }

    private val stopReceiver = object : android.content.BroadcastReceiver() {

        override fun onReceive(
            context: android.content.Context?,
            intent: Intent?
        ) {
            if (intent?.action == "com.mouse.app.STOP_MOUSE") {
                hideCursor()
            }
        }
    }

    override fun onCreate() {
        super.onCreate()

        val filter = IntentFilter("com.mouse.app.STOP_MOUSE")

        if (Build.VERSION.SDK_INT >= 33) {
            registerReceiver(
                stopReceiver,
                filter,
                android.content.Context.RECEIVER_NOT_EXPORTED
            )
        } else {
            registerReceiver(stopReceiver, filter)
        }
    }
}
