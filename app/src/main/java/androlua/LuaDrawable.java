package androlua;


import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.drawable.Drawable;
import com.luajava.LuaException;
import com.luajava.LuaFunction;
import com.luajava.LuaObject;

public class LuaDrawable extends Drawable {
    private final LuaContext mContext = this.mDraw.getLuaState().getContext();
    private LuaObject mDraw;
    private LuaFunction mOnDraw;
    private Paint mPaint = new Paint();

    public LuaDrawable(LuaFunction func) {
        this.mDraw = func;
    }

    public void draw(Canvas p1) {
        try {
            if (this.mOnDraw == null) {
                Object r = this.mDraw.call(p1, this.mPaint, this);
                if (r != null && (r instanceof LuaFunction)) {
                    this.mOnDraw = (LuaFunction) r;
                }
            }
            if (this.mOnDraw != null) {
                this.mOnDraw.call(p1);
            }
        } catch (LuaException e) {
            this.mContext.toast(e.getMessage());
        }
    }

    public void setAlpha(int p1) {
        this.mPaint.setAlpha(p1);
    }

    public void setColorFilter(ColorFilter p1) {
        this.mPaint.setColorFilter(p1);
    }

    public int getOpacity() {
        return PixelFormat.UNKNOWN;
    }

    public Paint getPaint() {
        return this.mPaint;
    }
}