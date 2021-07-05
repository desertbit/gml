/*
 * GML - Go QML
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Roland Singer <roland.singer[at]desertbit.com>
 * Copyright (c) 2019 Sebastian Borchers <sebastian[at]desertbit.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "gml_list_model.h"

//########################//
//### Static Variables ###//
//########################//

gml_list_model_row_count_cb_t gml_list_model_row_count_cb = NULL;
gml_list_model_data_cb_t      gml_list_model_data_cb      = NULL;

//#############//
//### C API ###//
//#############//

gml_list_model gml_list_model_new(void* go_ptr) {
    try {
        GmlListModel* glm = new GmlListModel(go_ptr);
        return (gml_list_model)glm;
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
        return NULL;
    }
    catch (...) {
        gml_error_log_exception();
        return NULL;
    }
}

void gml_list_model_free(gml_list_model lm) {
    if (lm == NULL) {
        return;
    }
    GmlListModel* glm = (GmlListModel*)lm;
    delete glm;
    lm = NULL;
}

void gml_list_model_cb_register(
    gml_list_model_row_count_cb_t rc_cb,
    gml_list_model_data_cb_t      d_cb
) {
    gml_list_model_row_count_cb = rc_cb;
    gml_list_model_data_cb      = d_cb;
}

void gml_list_model_begin_reset_model(gml_list_model lm) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitBeginResetModel();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_list_model_end_reset_model(gml_list_model lm) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitEndResetModel();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_list_model_begin_insert_rows(gml_list_model lm, int row, int count) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitBeginInsertRows(row, count);
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_list_model_end_insert_rows(gml_list_model lm) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitEndInsertRows();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_list_model_begin_move_rows(gml_list_model lm, int row, int count, int dst_row) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitBeginMoveRows(row, count, dst_row);
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_list_model_end_move_rows(gml_list_model lm) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitEndMoveRows();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_list_model_rows_data_changed(gml_list_model lm, int row, int count) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitRowsDataChanged(row, count);
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_list_model_begin_remove_rows(gml_list_model lm, int row, int count) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitBeginRemoveRows(row, count);
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_list_model_end_remove_rows(gml_list_model lm) {
    try {
        GmlListModel* glm = (GmlListModel*)lm;
        glm->emitEndRemoveRows();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

//##########################//
//### GmlListModel Class ###//
//##########################//

GmlListModel::GmlListModel(
    void* goPtr
) : goPtr(goPtr) {}

int GmlListModel::rowCount(const QModelIndex& /*parent = QModelIndex()*/) const {
    // Call to go.
    return gml_list_model_row_count_cb(goPtr);
}

QVariant GmlListModel::data(const QModelIndex& index, int /*role = Qt::DisplayRole*/) const {
    // Call to go.
    gml_variant gmlV = gml_list_model_data_cb(goPtr, index.row());

    // Create a copy.
    QVariant v(*((QVariant*)gmlV));

    // Delete, because Go is not responsible for memory anymore.
    gml_variant_free(gmlV);

    return v;
}

void GmlListModel::emitBeginResetModel() {
    emit beginResetModel();
}

void GmlListModel::emitEndResetModel() {
    emit endResetModel();
}

void GmlListModel::emitBeginInsertRows(int row, int count) {
    emit beginInsertRows(QModelIndex(), row, row+count-1);
}

void GmlListModel::emitEndInsertRows() {
    emit endInsertRows();
}

void GmlListModel::emitBeginMoveRows(int row, int count, int dstRow) {
    emit beginMoveRows(QModelIndex(), row, row+count-1, QModelIndex(), dstRow);
}

void GmlListModel::emitEndMoveRows() {
    emit endMoveRows();
}

void GmlListModel::emitRowsDataChanged(int row, int count) {
    emit dataChanged(createIndex(row, 0), createIndex(row+count-1, 0));
}

void GmlListModel::emitBeginRemoveRows(int row, int count) {
    emit beginRemoveRows(QModelIndex(), row, row+count-1);
}

void GmlListModel::emitEndRemoveRows() {
    emit endRemoveRows();
}
